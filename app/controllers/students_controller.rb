class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy duplicate downloadcontractitalian downloadcontractenglish download_final_libretto]

  # Autorizaciones
  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update]
  before_action :authorize_admin, only: [:destroy]
  before_action :authorize_to_see, only: [:index, :show, :courseattendancesexport, :attendancesexport,
    :export_ministerio_anagrafica, :export_full_anagrafica ]


  # GET /students or /students.json
  def index
    @students = Student.where(user: User.where(:role_id => Role.find_by(:name => 'Student').id)).order(:lastname, :name)
    @stays = Stay.where(acyear_id: $year.id)
    @anno = $year
    if params[:acyear_filter] == "" or params[:name_filter] == ""
      @students = Student.where(user: User.where(:role_id => Role.find_by(:name => 'Student').id)).order(:lastname, :name)
      @stays = Stay.where(acyear_id: $year.id)
      @anno = $year
    else
      if params[:acyear_filter]
        @stays = Stay.where(acyear_id: params[:acyear_filter])
        @anno = Acyear.find_by_id(params[:acyear_filter])
        if @stays
          @students = Student.where(id: @stays.pluck(:student_id)).order(:lastname, :name)
        else
          @students = Student.where(user: User.where(:role_id => Role.find_by(:name => 'Student').id)).order(:lastname, :name)
        end
      end
      if params[:name_filter]
        @students = Student.where(id: params[:name_filter]).order(:lastname, :name)
        @stays = Stay.where(student_id: @students.pluck(:id))
        @anno = $year
      end
    end
  end

  # Para la vista de las asistencias a los cursos
  def courseattendance
  end

  def courseattendancesexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @students = Student.where(id: @stays.pluck(:student_id))
      #@courseattendances = Courseattendance.where(student_id: @students.pluck(:id), 'perc_attendance >': 0)
      # tuve que filtrar de este modo porque no fui capaz de poner que perc_attendances > 0
      @courseattendances = Courseattendance.where(student_id: @students.pluck(:id))
      if params[:nombre] == "sin_participacion_minima"
        @courseattendances = @courseattendances.where.not(perc_attendance: ..0)
      end
      if params[:nombre] == "con_participacion_minima"
        @courseattendances = @courseattendances.joins(:course).where('courses.min_attendance <= perc_attendance')
      end
    else
      redirect_to reports_path
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Ministero_Anagrafica_Partecipazione_Attivita_#{Date.today}.csv"
      end
    end
  end


  # Para exportar las attendances a las actividades
  def attendancesexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @students = Student.where(id: @stays.pluck(:student_id))
    else
      redirect_to reports_path
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Ministero_Anagrafica_Partecipazione_Lezione#{Date.today}.csv"
      end
    end
  end


  # Para exportar las locations
  def export_ministerio_anagrafica
  #def students_min_anagrafica_export
    @stays = Stay.where(acyear_id: params[:acyear_filter])
    @students = Student.where(id: @stays.pluck(:student_id))
    @acyearid = params[:acyear_filter]
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Ministero_Anagrafica_Studenti#{Date.today}.csv"
      end
    end
  end

  # Para exportar las locations
  def export_full_anagrafica
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @students = Student.where(id: @stays.pluck(:student_id))
      @anno = Acyear.find_by_id(params[:acyear_filter])
    else
      @students = Student.where(user: User.where(role_id: Role.find_by(name: 'Student').id)).order(:lastname, :name)
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Anagrafica_Studenti_Completa#{Date.today}.csv"
      end
    end
  end

  # Para remover las imagenes de los estudiantes
  def purge_avatar
    @student = Student.find(params[:id])
    @student.profile_picture.purge_later
    redirect_back fallback_location: students_path, notice: "La foto è stata cancellata"
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # No se pueden crear estudiantes: se debe crear primero el usuario
  # GET /students/new
  def newnotworking
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Lo studente è stato creato con successo." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Lo studente è stato aggiornato con successo." }
        format.json { render :show, status: :see_other, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      #format.turbo_stream { render turbo_stream: turbo_stream.remove(@student)}
      format.html { redirect_to students_url, status: :see_other, notice: "Lo studente è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:name, :lastname, :email, :phone_number, :gender, :id_number,
        :country_of_birth, :city_of_birth, :birthdate, :profile_picture,
        :user_id,
         activity_ids:[],
         acyear_ids:[]
       )
    end
end
