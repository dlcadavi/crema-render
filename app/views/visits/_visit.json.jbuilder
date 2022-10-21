json.extract! visit, :id, :student_id,
  :hosting_start_date, :hosting_end_date,
  :fee, :annualfee,
  :created_at, :updated_at
json.url visit_url(visit, visit: :json)
