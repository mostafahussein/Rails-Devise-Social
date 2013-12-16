class Category < ActiveRecord::Base
  has_many :subcategories
  has_many :synonyms, dependent: :destroy
  
  attr_accessible :description, :icon, :name

  validates_presence_of :name
  validates_uniqueness_of :name
  
  
  def self.autocomplete(field, query_pattern)
    categories = Category.where("#{field} LIKE ?", "%#{query_pattern}%")
    categories.map { |item| item.send(field)}
  end
  
end