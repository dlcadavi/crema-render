class AddProgramToStay < ActiveRecord::Migration[7.0]
  def change
    add_reference :stays, :program, null: true, foreign_key: true
  end
end
