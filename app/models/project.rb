class Project < ActiveRecord::Base
  AVAILABLE_STATUS = [ :open, :assigned_to_a_company, :closed, :cancelled ]
  belongs_to :user
  belongs_to :region

  has_many :project_options
  has_many :options, through: :project_options

  has_many :tags, :through => :taggings
  has_many :taggings, :as => :taggable

  has_many :attachments, :as => :parent

  scope :opened, where(status: "open")

  has_many :messages

  has_many :company_projects
  has_many :companies, :through => :company_projects

  before_create :set_default_status
  accepts_nested_attributes_for :project_options, allow_destroy: true

  attr_accessible :name, :budget, :start_date, :end_date, :data,
                  :user, :description, :long_description,
                  :date, :timeframe, :attachments,
                  :project_options_attributes, :region_id, :currency, :subcategory

  attr_accessor :subcategory

  validates_uniqueness_of :name, :scope => :project_type_id

  validate :starts_at_is_less_than_ends_at,
           :starts_at_is_less_than_today,
           :quote_options, :check_status
  serialize :data, JSON

  def title
    self.name.blank? ? "No title" : self.name
  end

  def posted_ago
    require 'code_extensions.rb'
    CodeExtensions::TIME_AGO.(created_at)
  end

  def category
    options.empty? ? nil : options.first.question.subcategory.category
  end

  private

  def check_status
    errors.add(:status, " should be in #{AVAILABLE_STATUS.join(', ')}") unless self.status.blank? || AVAILABLE_STATUS.include?(self.status)
  end

  def quote_options
    if subcategory
      subcategory.questions.where(is_mandatory: true).each do |q|
        if Answer.where(id: project_options.map(&:answer_id)).where(question_id: q.id).empty?
          # TODO fix and move message to de.yml
          errors.add(:"quotes_#{q.id}", 'Bitte beantworten Sie diese Frage')
        end
      end
    end
  end

  def starts_at_is_less_than_ends_at
    if self.end_date
      errors.add(:end_date, "Enddatum ist kleiner als das Startdatum") if (start_date > end_date)
    end
  end

  def starts_at_is_less_than_today
    if self.start_date
      errors.add(:start_date, "Startdatum ist weniger als heute") if (Date.today > start_date)
    end
  end

  def set_default_status
    self.status = :open if self.status.blank?
  end

end

