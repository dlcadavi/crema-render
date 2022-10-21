json.extract! guest, :id, :name, :lastname, :id_number, :birthdate, :hosting_start_date, :hosting_end_date, :email, :phone_number, :fee, :annualfee, :months, :gender, :university, :country_of_birth, :created_at, :updated_at
json.url guest_url(guest, format: :json)
