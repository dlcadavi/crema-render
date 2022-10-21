class AddExamfreeToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :examfree, :boolean
  end
end
