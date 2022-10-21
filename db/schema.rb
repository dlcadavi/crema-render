# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_19_033118) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.text "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.text "key", null: false
    t.text "filename", null: false
    t.text "content_type"
    t.text "metadata"
    t.text "service_name", null: false
    t.bigint "byte_size", null: false
    t.text "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.text "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.decimal "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_enrollments"
    t.string "context"
    t.string "kind"
    t.datetime "activity_date", precision: nil
    t.string "aggregated_qualification"
    t.float "cost"
    t.boolean "confirmed_date"
    t.bigint "acyear_id"
    t.string "professor_fullname"
    t.integer "total_attendances"
    t.string "students_enrolled"
    t.string "students_attendance"
    t.string "subtitle"
    t.index ["acyear_id"], name: "index_activities_on_acyear_id"
  end

  create_table "activitycourses", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activitycourses_on_activity_id"
    t.index ["course_id"], name: "index_activitycourses_on_course_id"
  end

  create_table "acyears", force: :cascade do |t|
    t.string "name"
    t.date "startdate"
    t.date "finaldate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activity_id"
    t.bigint "student_id"
    t.index ["activity_id"], name: "index_attendances_on_activity_id"
    t.index ["student_id"], name: "index_attendances_on_student_id"
  end

  create_table "courseattendances", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "hours"
    t.float "total_activities"
    t.float "perc_attendance"
    t.index ["course_id"], name: "index_courseattendances_on_course_id"
    t.index ["student_id"], name: "index_courseattendances_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "context"
    t.string "typology"
    t.string "professor"
    t.float "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numberactivities"
    t.string "aggregated_qualification"
    t.float "min_attendance"
    t.datetime "date"
    t.bigint "acyear_id"
    t.float "duration"
    t.datetime "end_date"
    t.integer "deleteconfirmation"
    t.index ["acyear_id"], name: "index_courses_on_acyear_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_enrollments_on_activity_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "gradesmins", force: :cascade do |t|
    t.string "area"
    t.integer "year"
    t.float "grades"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "graduations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stay_id"
    t.date "graduation_date"
    t.float "grades"
    t.string "tipo"
    t.boolean "lode"
    t.boolean "encomio"
    t.index ["stay_id"], name: "index_graduations_on_stay_id"
  end

  create_table "guests", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "id_number"
    t.date "birthdate"
    t.date "hosting_start_date"
    t.date "hosting_end_date"
    t.string "email"
    t.string "phone_number"
    t.float "fee"
    t.float "annualfee"
    t.float "months"
    t.string "gender"
    t.string "university"
    t.string "country_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stay_id"
    t.date "start_location_date"
    t.date "end_location_date"
    t.float "fee"
    t.string "room"
    t.string "description"
    t.float "months"
    t.float "totalfee"
    t.index ["stay_id"], name: "index_locations_on_stay_id"
  end

  create_table "mobilities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stay_id"
    t.date "start_mobility_date"
    t.date "end_mobility_date"
    t.string "country"
    t.string "mobility_program"
    t.string "description"
    t.float "months"
    t.index ["stay_id"], name: "index_mobilities_on_stay_id"
  end

  create_table "professoractivities", force: :cascade do |t|
    t.integer "professor_id"
    t.integer "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "cost"
    t.boolean "present"
  end

  create_table "professorcourses", force: :cascade do |t|
    t.integer "professor_id"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string "name"
    t.string "lastname"
    t.string "email"
    t.string "phone_number"
    t.string "id_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hours_lectured"
    t.integer "number_activities_lectured"
    t.string "qualification"
    t.string "activitiesname"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stays", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id"
    t.bigint "acyear_id"
    t.date "hosting_start_date"
    t.date "hosting_end_date"
    t.string "year_enrollment"
    t.float "fee"
    t.float "periodgrades"
    t.float "cumulativegrades"
    t.boolean "fee_reduction_request"
    t.boolean "firsttime"
    t.float "annualfee"
    t.float "months"
    t.string "typology"
    t.string "frame"
    t.float "hours_attended"
    t.integer "number_activities_attended"
    t.string "attendance_status"
    t.string "cumulativegrades_status"
    t.string "periodgrades_status"
    t.string "kind"
    t.bigint "program_id"
    t.float "gradesmin"
    t.float "perc_attendance"
    t.float "min_hours_required"
    t.string "kindcode"
    t.boolean "grant"
    t.float "monthsfee"
    t.boolean "examfree"
    t.index ["acyear_id"], name: "index_stays_on_acyear_id"
    t.index ["program_id"], name: "index_stays_on_program_id"
    t.index ["student_id"], name: "index_stays_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.text "name"
    t.text "id_number"
    t.text "country_of_birth"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lastname"
    t.string "email"
    t.string "phone_number"
    t.string "gender"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "role_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "lastname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "visits", force: :cascade do |t|
    t.date "hosting_start_date"
    t.date "hosting_end_date"
    t.float "fee"
    t.float "months"
    t.float "annualfee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guest_id"
    t.bigint "acyear_id"
    t.string "description"
    t.index ["acyear_id"], name: "index_visits_on_acyear_id"
    t.index ["guest_id"], name: "index_visits_on_guest_id"
  end

  create_table "years", force: :cascade do |t|
    t.string "name"
    t.date "startdate"
    t.date "finaldate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "acyears"
  add_foreign_key "activitycourses", "activities"
  add_foreign_key "activitycourses", "courses"
  add_foreign_key "courseattendances", "courses"
  add_foreign_key "courseattendances", "students"
  add_foreign_key "courses", "acyears"
  add_foreign_key "enrollments", "activities"
  add_foreign_key "enrollments", "users"
  add_foreign_key "graduations", "stays"
  add_foreign_key "locations", "stays"
  add_foreign_key "mobilities", "stays"
  add_foreign_key "stays", "programs"
  add_foreign_key "students", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "visits", "acyears"
end
