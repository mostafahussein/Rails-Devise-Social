class BillingAddr < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :first_name, :last_name, :phone, :addr1, :addr2, :country_id, :city, :province, :postal_code
end
