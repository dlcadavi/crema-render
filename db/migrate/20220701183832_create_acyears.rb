class CreateAcyears < ActiveRecord::Migration[7.0]
  def change
    create_table :acyears do |t|
      t.string :name
      t.date :startdate
      t.date :finaldate

      t.timestamps
    end
  end
end
