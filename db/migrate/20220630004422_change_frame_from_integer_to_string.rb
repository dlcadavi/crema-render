class ChangeFrameFromIntegerToString < ActiveRecord::Migration[7.0]
  def up
    change_column :students, :frame, :string
  end

  def down
    change_column :students, :frame, :integer
  end
end
