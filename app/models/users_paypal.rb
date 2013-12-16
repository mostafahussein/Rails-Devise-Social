class UsersPaypal < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_id, :paypal_addr
  
end
