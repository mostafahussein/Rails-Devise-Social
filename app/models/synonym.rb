class Synonym < ActiveRecord::Base
  
  belongs_to :category
  belongs_to :subcategory
  
  attr_accessible :category_id, :name, :subcategory_id
  
  def self.autocomplete(field, query_pattern)
    synonyms = Synonym.where("#{field} LIKE ?", "%#{query_pattern}%")
    synonyms.map{|item| item.send(field)}        
  end
end
