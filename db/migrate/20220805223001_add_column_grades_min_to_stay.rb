class AddColumnGradesMinToStay < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :gradesmin, :float
  end
end
