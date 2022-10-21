json.extract! course, :id, :name, :description, :context, :typology, :professor, :cost, :professor_ids, :created_at, :updated_at
json.url course_url(course, format: :json)
