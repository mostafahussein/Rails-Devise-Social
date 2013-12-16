class CreateUsersPaypals < ActiveRecord::Migration
  def change
    create_table :users_paypals do |t|
      t.integer :user_id
      t.string  :paypal_addr
      t.timestamps
    end
  end
end
