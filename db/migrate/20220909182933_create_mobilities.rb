class CreateMobilities < ActiveRecord::Migration[7.0]
  def change
    create_table :mobilities do |t|

      t.timestamps
    end
  end
end
