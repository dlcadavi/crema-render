class RemoveHostingStartDateFromGuests < ActiveRecord::Migration[7.0]
  def change
    remove_column :guests, :hosting_start_date
    remove_column :guests, :hosting_end_date
    remove_column :guests, :fee
    remove_column :guests, :annualfee
    remove_column :guests, :months
  end
end
