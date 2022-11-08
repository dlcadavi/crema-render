class AddProgramToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_reference :graduations, :program, null: true, foreign_key: true
  end
end
