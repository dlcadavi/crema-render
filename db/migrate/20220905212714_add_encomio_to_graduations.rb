class AddEncomioToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_column :graduations, :encomio, :boolean
  end
end
