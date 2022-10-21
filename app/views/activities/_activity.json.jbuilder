json.extract! activity, :id, :name, :description, :duration, :activity_date, :kind, :professor_fullname, :qualificator, :context, :total_enrollments, :student_ids, :professor_ids, :created_at, :updated_at
json.url activity_url(activity, format: :json)
