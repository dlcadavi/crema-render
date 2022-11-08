class AddTipoToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :tipo, :string
  end
end
