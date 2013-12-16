class UsersBilling < ActiveRecord::Base
  # attr_accessible :title, :body        
  attr_accessible :user_id, :payment_method_id, :billing_addrs_id
  
end
