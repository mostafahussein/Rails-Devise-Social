class RemoveLongDescription < ActiveRecord::Migration
  def change
    remove_column :companies, :long_description
  end
end
