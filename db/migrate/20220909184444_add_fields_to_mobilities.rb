class AddFieldsToMobilities < ActiveRecord::Migration[7.0]
  def change
    add_column :mobilities, :start_mobility_date, :date
    add_column :mobilities, :end_mobility_date, :date
    add_column :mobilities, :country, :string
    add_column :mobilities, :mobility_program, :string
    add_column :mobilities, :description, :string
  end
end
