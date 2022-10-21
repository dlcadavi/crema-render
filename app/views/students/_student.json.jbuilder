json.extract! student, :id, :name, :id_number, :country_of_birth, :city_of_birth, :birthdate, :program_level, :program_name, :hosting_start_date, :hosting_end_date,
  :hours_attended, :number_activities_attended,
  :tipology, :frame, :kind, :year_enrollment, :fee, :annualfee, :fee_reduction_request, :firsttime, :gender,
  :activity_ids,
  :user_id,
  :created_at, :updated_at
json.url student_url(student, format: :json)
