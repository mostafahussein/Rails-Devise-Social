class AddStatusColumnToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :status, :string, :limit => 50
  end
end
