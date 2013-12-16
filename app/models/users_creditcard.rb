class UsersCreditcard < ActiveRecord::Base
  # attr_accessible :title, :body

  attr_accessible :user_id, :customer_profile_id, :card_type_id, :exp_year, :exp_month, :cvv2  
      
end
