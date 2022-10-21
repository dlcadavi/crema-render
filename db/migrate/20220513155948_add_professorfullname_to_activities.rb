class AddProfessorfullnameToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :professor_fullname, :string
  end
end
