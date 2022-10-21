class CreateGradesmins < ActiveRecord::Migration[7.0]
  def change
    create_table :gradesmins do |t|
      t.string :area
      t.integer :year
      t.float :grades

      t.timestamps
    end
  end
end
