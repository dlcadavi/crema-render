class CreateProfessors < ActiveRecord::Migration[7.0]
  def change
    create_table :professors do |t|
      t.string :name
      t.string :lastname
      t.string :email
      t.integer :phone_number
      t.string :id_number

      t.timestamps
    end
  end
end
