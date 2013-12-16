class Attachment < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true

  image_accessor :file
  attr_accessible :file, :file_name, :parent

  def attach_size
    self.file.size
  end

  def attach_type
    self.file.mime_type
  end
end