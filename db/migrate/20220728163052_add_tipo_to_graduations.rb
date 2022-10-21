class AddTipoToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_column :graduations, :tipo, :string
  end
end
