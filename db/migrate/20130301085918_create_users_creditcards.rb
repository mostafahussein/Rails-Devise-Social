class CreateUsersCreditcards < ActiveRecord::Migration
  def change
    create_table :users_creditcards do |t|
      t.integer :user_id
      t.integer :customer_profile_id
      t.integer :card_type_id
      t.integer :exp_year
      t.integer :exp_month
      t.string  :cvv2

      t.timestamps
    end
  end
end
