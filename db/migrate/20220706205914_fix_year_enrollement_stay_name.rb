class FixYearEnrollementStayName < ActiveRecord::Migration[7.0]
  def up
    rename_column :stays, :ear_enrollment, :year_enrollment
  end

  def down
    rename_column :stays, :year_enrollment, :ear_enrollment
  end
end
