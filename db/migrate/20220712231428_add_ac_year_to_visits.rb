class AddAcYearToVisits < ActiveRecord::Migration[7.0]
  def change
    add_reference :visits, :acyear, null: true, foreign_key: true
  end
end
