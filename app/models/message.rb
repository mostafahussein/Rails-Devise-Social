class Message < ActiveRecord::Base

  belongs_to :sender, :foreign_key => "from_id", :class_name => "User"
  belongs_to :recipient, :foreign_key => "to_id", :class_name => "User"
  belongs_to :project
  
  has_many :attachments, :as => :parent

  attr_accessible :subject, :body, :sender, :recipient, :project, :previousmessage
  
  validates_presence_of :subject, :sender, :recipient

  def posted_ago
    require 'code_extensions.rb'
    CodeExtensions::TIME_AGO.(created_at)
  end

end