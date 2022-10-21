class ChangePhoneNumberToBeStringInProfessors < ActiveRecord::Migration[7.0]
  def up
    change_column :professors, :phone_number, :string
  end

  def down
    change_column :professors, :phone_number, :integer
  end

end
