class AddKindToStays < ActiveRecord::Migration[7.0]
  def change
    add_column :stays, :kind, :string
  end
end
