class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :name
      t.string :code
      t.string :area

      t.timestamps
    end
  end
end
