class CreateSynonyms < ActiveRecord::Migration
  def change
    create_table :synonyms do |t|
      t.integer :category_id
      t.integer :subcategory_id
      t.string :name

      t.timestamps
    end
  end
end
