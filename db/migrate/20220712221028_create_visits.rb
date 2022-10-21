class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.date :hosting_start_date
      t.date :hosting_end_date
      t.float :fee
      t.float :months
      t.float :annualfee

      t.timestamps
    end
  end
end
