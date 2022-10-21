class AddStayToGraduations < ActiveRecord::Migration[7.0]
  def change
    add_reference :graduations, :stay, null: true, foreign_key: true
  end
end
