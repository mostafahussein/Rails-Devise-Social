class CreateCreditcardTypes < ActiveRecord::Migration
  def change
    create_table :creditcard_types do |t|
      
      t.string  :name
            
      t.timestamps
    end
  end
end
