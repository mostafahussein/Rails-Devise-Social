class CreateBillingAddrs < ActiveRecord::Migration
  def change
    create_table :billing_addrs do |t|
      
      t.string  :first_name
      t.string  :last_name
      t.string  :phone
      t.string  :addr1
      t.string  :addr2      
      
      t.integer :country_id
      
      t.string  :city
      t.string  :province
      t.string  :postal_code
      
      t.timestamps
    end
  end
end
