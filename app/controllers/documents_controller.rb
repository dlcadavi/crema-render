class DocumentsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_to_see, only: [:index,
    :download_model_italian_student_contract,
    :download_model_english_student_contract,
    :download_model_italian_professor_contract,
    :download_model_initial_libretto,
    :download_model_final_libretto,
    :download_students_grades,
  ]

  before_action :authorize_to_edit, only: [:upload, :set_voti]

  def index
  end

  # Para cargar el contrato en italiano
  def upload
    if params[:file].present?
      uploaded_io = params[:file]
      nombre_archivo = params[:nombre]
      File.open(Rails.root.join('app', 'assets', 'templates', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
          @uniq_path = Rails.root.join('app', 'assets', 'templates', nombre_archivo + File.extname(file))
          File.rename(file, @uniq_path)
          respond_to do |format|
              format.html { redirect_to(documents_url, :notice => 'Il file è stato caricato con successo.') }
          end
        end
      end
      if nombre_archivo == "students_grades"
        set_voti
      end
    end

    # Cargar el csv con las notas de los estudiantes y asignárselas a cada estudiante
    def set_voti
      #Para cambiar los números de coma a punto (las notas separadas con decimales en comas)
      comma_numbers = ->(s) {(s =~ /^\d+,/) ? (s.gsub(',' , '.').to_f) : s}
      CSV::Converters[:comma_numbers] = comma_numbers

      ruta = "#{Rails.root}/app/assets/templates/"
      filename = ruta+"students_grades"+'.csv'

      CSV.foreach(filename, headers: true, skip_blanks: true, converters: [:all, :comma_numbers]) do |row|
        anno,cf,voti_periodo,voti_carriera = row
        @student = Student.find_by(id_number: cf)
        if !@student.nil?
          @anno = Acyear.find_by(name: anno)
          @stay = Stay.where(student_id: @student.id, acyear_id: @anno.id).first
          @stay.update_column :periodgrades, voti_periodo[1]
          @stay.update_column :cumulativegrades, voti_carriera[1]
        end
      end
    end


    def download_model_italian_student_contract
      send_file("#{Rails.root}/app/assets/templates/contract_italian.docx")
    end
    def download_model_english_student_contract
      send_file("#{Rails.root}/app/assets/templates/contract_english.docx")
    end
    def download_model_italian_professor_contract
      send_file("#{Rails.root}/app/assets/templates/contract_professors_italian.docx")
    end
    def download_model_initial_libretto
      send_file("#{Rails.root}/app/assets/templates/initial_libretto.docx")
    end
    def download_model_final_libretto
      send_file("#{Rails.root}/app/assets/templates/final_libretto.docx")
    end
    def download_students_grades
      send_file("#{Rails.root}/app/assets/templates/students_grades.csv")
    end

end
