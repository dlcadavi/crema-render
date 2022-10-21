json.extract! stay, :id, :acyear_id, :student_id,
  :hosting_start_date, :hosting_end_date,
  :year_enrollment, :fee, :annualfee, :fee_reduction_request, :firsttime,
  :created_at, :updated_at
json.url stay_url(stay, student: :json)
