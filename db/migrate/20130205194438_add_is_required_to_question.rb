class AddIsRequiredToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :is_mandatory, :boolean, default: false
  end
end
