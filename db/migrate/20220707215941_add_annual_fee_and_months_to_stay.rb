class AddAnnualFeeAndMonthsToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :annualfee, :float
    add_column :stays, :months, :float
  end
end
