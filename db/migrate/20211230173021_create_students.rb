class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.text :name
      t.text :id_number
      t.text :country_of_birth
      t.text :city_of_birth
      t.date :birthdate
      t.text :program_level
      t.text :program_name
      t.date :hosting_start_date
      t.date :hosting_end_date
      t.text :image_url

      t.timestamps
    end
  end
end
