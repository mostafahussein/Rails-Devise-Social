class UsersInvoce < ActiveRecord::Base
  # attr_accessible :title, :body      
  attr_accessible :user_id, :invoice_id, :billing_addrs_id, :invoice_file_name
end
