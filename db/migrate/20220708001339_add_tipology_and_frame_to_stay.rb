class AddTipologyAndFrameToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :typology, :string
    add_column :stays, :frame, :string
  end
end
