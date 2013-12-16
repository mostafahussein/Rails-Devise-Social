class Company < ActiveRecord::Base
  PER_PAGE = 10

  belongs_to :city
  belongs_to :region
  belongs_to :user
  
  has_many :images, :as => :imageable
  has_many :reviews, :as => :reviewable
  has_many :tags, :through => :taggings
  has_many :taggings, :as => :taggable

  has_many :company_projects
  has_many :projects, :through => :company_projects

  has_many :company_subcategories
  has_many :subcategories, :through => :company_subcategories
  
  has_many :activity_regions
  has_many :regions, :through => :activity_regions
 
  image_accessor :cover_image

  attr_accessor :registration_step
  attr_accessible :user, :user_id, :city, :city_id, :region_id, :region, :name, :email,
                  :contact_person, :postal_code, :latitude, :longitude,
                  :description, :address, :phone_numbers,
                  :websites, :thumbnail, :cover_image,
                  :draft, :sponsor, :reviews, :registration_step
                  
  accepts_nested_attributes_for :city, :region

  serialize :phone_numbers, JSON
  serialize :websites, JSON

  before_create :generate_uid

  validate :validate_creation
  validates_presence_of :name
  validates_uniqueness_of :name

  #validates_each :phone_numbers, :allow_nil => true do |record, attr, phone_numbers|
  # phone_numbers.each do |phone_number|
  #    unless phone_number.strip.blank? or phone_number =~ /^[0-9\(\)\- ]+$/
  #      record.errors.add(attr, 'Invalid phone number format')
  #    end
  #  end
  #end

  before_save :filter_blank_phone_numbers
  before_save :filter_blank_websites
  before_save :filter_html_tags
  before_save :denormalize_region_and_city

  scope :by_alphabetical, order(:name)
  scope :sponsors,                  where(:sponsor => true)
  scope :of_uid,          ->(uid) { where(:uid => uid)}
  scope :of_region_id,    ->(region) { where(:region_id => region)}
  scope :without_company, ->(company) { where("id <> ?", company.id) }
  scope :of_tag,          ->(tag_name) { joins(:tags).where("tags.name = ?", tag_name.downcase) }
  scope :of_name_like,    ->(name) { where("lower(name) LIKE ?", name.downcase) }
  scope :of_region_name,  ->(region) { where("lower(region_name) LIKE ?", region.downcase) }
  scope :of_city_name,    ->(city) { where("lower(city_name) LIKE ?", city.downcase ) }
  
  def validate_creation
   
    if self[:registration_step] == 1
      validate_first_step
    elsif self[:registration_step] == 2
      validate_second_step
    elsif self[:registration_step] == 3
      validate_third_step
    end
  end
  
  def validate_first_step
    default_region_id = 0
   
    #check name presence
    if self[:name].blank?
      errors.add :name, "#{I18n.t('companyname')} #{I18n.t('errors.messages.blank')}"
    end
   
    #check name uniqueness   
    scp = Company.where(:name => self[:name])
    scp = scp.where("id <> ?", self.id) unless self.new_record?
    if scp.exists?
      errors.add :name, I18n.t('errors.messages.company.company_name_must_be_unique')
    end

    #check region choosing
    if self[:region_id] == default_region_id
      errors.add :region, I18n.t('errors.messages.company.company_location_must_not_be_default')
    end
  end

  def validate_second_step
    min_description_length = 100;
    email_regexp = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    postal_code_regexp = /\d{4}/
    phome_number_regexp = /((00\d{4}|0\d{2}|\+\d{4})\d{7})+/ 

    #check contact person presence
    if self[:contact_person].blank?
      errors.add :contact_person, "#{I18n.t('contactperson')} #{I18n.t('errors.messages.blank')}" 
    end
   
    #check address presence   
    if self[:address].blank?
      errors.add :address, "#{I18n.t('address')} #{I18n.t('errors.messages.blank')}"
    end

    #check postal code presence
    if self[:postal_code].blank?
      errors.add :postal_code, "#{I18n.t('postal_code')} #{I18n.t('errors.messages.blank')}"
    end
    #check postal code format
    if errors[:postal_code].empty?
      matcher = postal_code_regexp.match(self[:postal_code])
      if matcher.nil? || !matcher.pre_match.blank? || !matcher.post_match.blank?
        errors.add :postal_code, I18n.t('errors.messages.4_digit_postal_code') 
      end
    end

    #check city presence
    if self[:city_id].nil?
      errors.add :city, "#{I18n.t('city')} #{I18n.t('errors.messages.blank')}"
    elsif self[:city_id] > 0
      #errors.add :city, "#{I18n.t('city')} #{I18n.t('errors.messages.invalid')}"
    end
    
    #check e-mail presence
    if self[:email].blank?
      errors.add :email, "#{I18n.t('email')} #{I18n.t('errors.messages.blank')}"
    end
    #check e-mail format
    if errors[:email].empty?
      matcher = email_regexp.match(self[:email])
      if matcher.nil? || !matcher.pre_match.blank? || !matcher.post_match.blank?
        errors.add :email, I18n.t('errors.messages.email')
      end
    end
    
    #check phone number format. there could be more than one number
    self[:phone_numbers].each do |single_phone_number|
      #remove '-' sings and whitespace and get each phone number
      temp_numbers = single_phone_number.gsub(/[\s-]/, "").split(',')      
      temp_numbers.each do |current_number|
        temp_matcher = phome_number_regexp.match(current_number) 
        if (temp_matcher.nil?) || !temp_matcher.post_match.blank? || !temp_matcher.pre_match.blank?  
          errors.add :phone_numbers, "#{I18n.t('phone')} #{I18n.t('errors.messages.invalid')}"
        end
      end
    end
    
    #check description presence
    if self[:description].nil? || self[:description].length < min_description_length
      errors.add :description, "#{I18n.t('description')} #{I18n.t('errors.messages.too_short', :count => '100')}"
    end
  end
  
  def validate_third_step
    #TODO add validation of 3-step data, if any mandatory fields appears
  end

  def rating
    # slow implementation, to be replaced
    rating = 0
    count = 0
    self.reviews.each do |review|
      rating += review.rating
      count += 1
    end
    if count > 0
      rating = rating / count
    end
    rating
  end

  def generate_uid
    token = rand(36**12).to_s(36)
    while Company.where(:uid => token).size > 0
      token = rand(36**12).to_s(36)
    end
    self.uid = token
  end

  def other_companies_from_region
    companies = Company.without_company(self).of_region_id(region)
    companies.sort! { |x, y| y.rating <=> x.rating }
    max = 5
    companies[0...max]
  end

  def self.autocomplete_clickable(field, query_pattern, &block)
    companies = Company.order(field).where("#{field} LIKE ?", "%#{query_pattern}%")
    links = companies.map { |item| block.call(item) }
    values = companies.map { |item| "#{item.send(field)}"}
    JqueryAutocomplete.array_of_clickable values, links
  end

  def self.autocomplete(field, query_pattern)
    companies = Company.order(field).where("#{field} LIKE ?", "%#{query_pattern}%")
    companies.map { |item| "#{item.send(field)}"}
  end
  

  def self.search_by_query(query_hash)
    page_index = query_hash[:page] || 1
    companies = Company.scoped
    if query_hash.present?
       companies = companies.of_name_like query_hash[:name] if query_hash[:name].present?
       companies = companies.of_region_name(query_hash[:region]) if query_hash[:region].present?
       companies = companies.of_city_name(query_hash[:city]) if query_hash[:city].present?
       companies = companies.of_tag(query_hash[:tag]) if query_hash[:tag].present?
    end 
    
    companies.page(page_index).per(Company::PER_PAGE)
  end 

private

  def filter_blank_phone_numbers
    return if self.phone_numbers.blank?
    self.phone_numbers.delete_if {|a| a.strip.blank? }
  end

  def filter_blank_websites
    return if self.websites.blank?
    self.websites.delete_if {|a| a.strip.blank? }
  end

  def filter_html_tags
    self.description = HTMLProcessor::filter_html(self.description) if self.description.present?
  end

  def denormalize_region_and_city
    self.region_name = self.region.name unless self.region.nil?
    self.city_name = self.city.name  unless self.city.nil?
  end

end
