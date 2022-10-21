class RemoveColumnsFromStudents < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :program_level
    remove_column :students, :program_name
    remove_column :students, :hosting_start_date
    remove_column :students, :hosting_end_date
    remove_column :students, :image_url
  end
end
