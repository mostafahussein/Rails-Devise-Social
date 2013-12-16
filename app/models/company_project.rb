class CompanyProject < ActiveRecord::Base
	belongs_to :company
	belongs_to :project
  attr_accessible :company, :project
end
