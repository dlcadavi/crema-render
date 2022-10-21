class AddAcYearToStays < ActiveRecord::Migration[7.0]
  def change
    add_reference :stays, :acyear
  end
end
