class AddAggregatedQualificationToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :aggregated_qualification, :string
  end
end
