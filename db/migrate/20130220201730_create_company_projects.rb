class CreateCompanyProjects < ActiveRecord::Migration
  def change
    create_table :company_projects do |t|
    	t.references  :company
    	t.references  :project
      t.timestamps
    end
  end
end
