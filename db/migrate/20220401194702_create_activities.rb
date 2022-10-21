class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.text :name
      t.text :description
      t.decimal :duration, precision: 1

      t.timestamps
    end
  end
end
