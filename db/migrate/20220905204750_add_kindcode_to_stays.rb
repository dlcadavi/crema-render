class AddKindcodeToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :kindcode, :string
  end
end
