class ChangeKindFromIntegerToString < ActiveRecord::Migration[7.0]
  def up
    change_column :activities, :kind, :string
  end

  def down
    change_column :activities, :kind, :integer
  end
end
