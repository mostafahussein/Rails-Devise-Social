class CreateUsersInvoces < ActiveRecord::Migration
  def change
    create_table :users_invoces do |t|
      t.integer   :user_id
      t.integer   :invoice_id
      t.integer   :billing_addrs_id
      t.string    :invoice_file_name
      
      t.timestamps
    end
  end
end
