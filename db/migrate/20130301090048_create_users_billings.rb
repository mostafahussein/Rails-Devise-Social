class CreateUsersBillings < ActiveRecord::Migration
  def change
    create_table :users_billings do |t|
      t.integer   :user_id
      t.integer   :payment_method_id
      t.integer   :billing_addrs_id
            
      t.timestamps
    end
  end
end
