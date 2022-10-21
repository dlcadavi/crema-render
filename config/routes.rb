Rails.application.routes.draw do
  resources :courses do
    collection do
      get :export_courses
    end
  end
  get 'courses(/:id)/activitycourse', to: 'activities#activitycourse', as:'activitycourse'


  # Tabla con las notas mínimas
  resources :gradesmins do
    collection {post :import}
  end

  # Tabla con los programas
  resources :programs do
    collection do
      post :import
      post :massive_destroy
    end
  end

  resources :locations, :except => [:new]
  get 'students(/:id)/locationstudent', to: 'locations#locationstudent', as:'locationstudent'
  get 'students(/:id)/location', to: 'locations#new', as:'new_location'
  get 'locations_export', to: 'locations#locationsexport'

  resources :mobilities, :except => [:new]
  get 'students(/:id)/mobilitystudent', to: 'mobilities#mobilitystudent', as:'mobilitystudent'
  get 'students(/:id)/mobility', to: 'mobilities#new', as:'new_mobility'
  get 'mobilities_export', to: 'mobilities#mobilitiesexport'

  resources :graduations, :except => [:new]
  get 'graduations_export', to: 'graduations#graduationsexport'
  get 'students(/:id)/graduationstudent', to: 'graduations#graduationstudent', as:'graduationstudent'
  get 'students(/:id)/graduation', to: 'graduations#new', as:'new_laurea'


  resources :guests do
    collection do
      get :export_guests
    end
  end

  resources :visits, :except => [:new] do
    member do
      get :downloadcontractitalian
      get :downloadcontractenglish
    end
  end
  get 'visits_export', to: 'visits#visitsexport'
  get 'guests(/:id)/visit', to: 'visits#new', as:'new_visit'
  get 'guests(/:id)/visitguest', to: 'visits#visitguest', as:'visitguest'

  # Que no genere la ruta new de las estadías porque se vincularán directamente con los estudiantes
  resources :stays, :except => [:new] do
    member do
      get :downloadcontractitalian
      get :downloadcontractenglish
      get :download_initial_libretto
      get :download_final_libretto
      get :studentactivities
      #get :staysexport
    end
    collection do

    end
  end
  get 'stays_export', to: 'stays#staysexport'
  get 'students(/:id)/stay', to: 'stays#new', as:'new_stadia'
  get 'students(/:id)/staystudent', to: 'stays#staystudent', as:'staystudent'


  resources :reports

  get 'reports_ministero', to: 'reports#ministero', as: 'report_ministero'
  get 'reports_other', to: 'reports#other', as: 'report_other'

  resources :acyears

  resources :attendances, :except => [:new]
  get 'activities(/:id)/attendanceactivity', to: 'attendances#attendanceactivity', as:'attendanceactivity'

  resources :professors do
    collection do
      get :export_professors
    end

    member do
      get :set_contract
      post :download_contratto_italiano
    end
  end
  get 'professors_export', to: 'professors#professorsexport'

  resources :students do
    # Para que se puedan subir los formatos relacionados con estudiantes (ej: contrato, etc)
    #collection {post :upload}
    collection do
      post :upload
      delete :bulk_destroy
      post :bulk_download
      get :export_full_anagrafica
      get :courseattendance
    end

    member do
      delete :purge_avatar
    end
  end
  get 'export_ministerio_anagrafica', to: 'students#export_ministerio_anagrafica'
  get 'export_full_anagrafica', to: 'students#export_full_anagrafica'



  # Crear la ruta para crear la estadía de estudiantes
  # get 'students(/:id)/studentstay', to: 'students#studentstay', as:'studentstay_student'


  # Página de inicio: login
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  #root "home#index"

  # Página donde se redirecciona según el tipo de usuario que hiz login
  get 'admindash', to: 'home#admindash', as:'admindash'
  get 'studentdash', to: 'home#studentdash', as:'studentdash'

  devise_for :users, :path_prefix => 'my', controllers: {
    #sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :users, only: [:index, :show, :edit, :update, :destroy]

  # Listado de las actividades para los estudiantes
  get 'myactivities', to: 'activities#user_activities', as:'user_activities'

  # Listado de los cursos para los estudiantes
  get 'mycourses', to: 'activities#user_courses', as:'user_courses'

  # Calendario de mis activiadades
  get 'mycalendar', to: 'activities#user_calendar', as:'user_calendar'

  # Calendario de todas las activiadades
  get 'calendar', to: 'activities#calendar', as:'calendar'

  # Modificado para que permita hacer los enrollments
  resources :activities do
    post :enroll
    post :unenrroll
    collection do
      get 'search'
      get :export_activities
    end
  end
  get 'activities(/:id)/editattendance', to: 'activities#editattendance', as:'editattendance'

  # Ruta para ver matricularse a las actividades
  # get 'activities(/:id)/enroll', to: 'activities#enroll', as:'enroll_activity'

  resources :documents do
    collection do
      post :upload
      get :download_model_italian_student_contract
      get :download_model_english_student_contract
      get :download_model_italian_professor_contract
      get :download_model_initial_libretto
      get :download_model_final_libretto
      get :download_students_grades
    end
  end



  # Configurar la página por defecto de la aplicación
  #root "students#index", as: "student_index"

  #get '/students/:id', to: 'students#dup'
  # get '/dup/students/:id', to: 'students#dup'

  get 'documents', to: 'documents#index', as: 'document_index'
  get 'documents_ministerio', to: 'documents#ministerio', as: 'document_ministerio'
  get 'documents_contract', to: 'documents#contract', as: 'document_contract'

# Crear la ruta para duplicar estudiantes y actividades (no está en el sistema CRUD esto de duplicar)
  get 'students(/:id)/duplicate', to: 'students#duplicate', as:'duplicate_student'
  get 'activities(/:id)/duplicate', to: 'activities#duplicate', as:'duplicate_activity'

  # Crear la ruta para ver las asistencias y exportarlas
  get 'attendances', to: 'students#attendances', as:'report_attendances'
  get 'attendances_export', to: 'students#attendancesexport'
  get 'courseattendances_export', to: 'students#courseattendancesexport'

  #get 'uploads', to: 'students#upload', as:'uploads'

  # Crear la ruta para exportar el contrato de cada estudiante
  #get 'students(/:id)/downloadcontractitalian', to: 'students#downloadcontractitalian', as:'export_contract_italian'

  #get '/students/dup', to: 'students#dup'
  #get 'dup_student', to: 'students#dup'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
