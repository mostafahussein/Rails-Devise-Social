class Question < ActiveRecord::Base
	AVAILABLE_TYPES = %w(select checkbox textarea)

	belongs_to :subcategory
	has_many :answers, dependent: :destroy

	validates :description, presence: true
  validates :question_type, presence: true, inclusion: {in: AVAILABLE_TYPES}

  attr_accessible :description, :question_type, :name, :subcategory, :is_mandatory

  def select?
  	question_type == 'select'
  end

  def checkbox?
  	question_type == 'checkbox'
  end

  def custom?
  	question_type == 'textarea'
  end

  def to_s
    self.description
  end
end
