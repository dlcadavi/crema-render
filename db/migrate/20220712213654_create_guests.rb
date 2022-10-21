class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests do |t|
      t.string :name
      t.string :lastname
      t.string :id_number
      t.date :birthdate
      t.date :hosting_start_date
      t.date :hosting_end_date
      t.string :email
      t.string :phone_number
      t.float :fee
      t.float :annualfee
      t.float :months
      t.string :gender
      t.string :university
      t.string :country_of_birth

      t.timestamps
    end
  end
end
