class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy editattendance]

  # Para asegurar que sólo usuarios registrados podrían ver esto
  before_action :authenticate_user!, except: %i[calendar]
  before_action :authorize_admin, except: %i[show user_activities user_courses enroll unenrroll user_calendar calendar]
  # Para verificar si es un usuario autorizado a ejecutar estas acciones
  #before_action :authorize_admin, except: %i[calendar user_activities user_courses]
  before_action :authorize_student, only: %i[user_activities user_courses enroll unenrroll user_calendar]


  def actualizar_campos_actividad
    @activities.each do |activity|
      #activity.calc_professor_fullname
      activity.calc_enrollment_and_attendance
    end
  end

  # Exportar a excel actividades para control del COllegio
  def export_activities
    if params[:acyear_filter] != ""
      @activities = Activity.where(acyear_id: params[:acyear_filter])
    else
      @activities = Activity.order(:activity_date, :name)
    end
    actualizar_campos_actividad
    atributos =%w{ name description activity_date duration kind professor_fullname aggregated_qualification context total_enrollments total_attendances students_enrolled students_attendance}          # acá se definen las columnas que quiero que vayan
    nombres_columnas = ["Argomento","Descrizione","Data","Ore","Tipo","Docente","Qualifica","Contesto", "Totale iscriti", "Totale presenti", "Studenti iscritti", "Studenti presenti"]            # acá le doy el nombre a las columnas
    send_data @activities.to_csv(@activities,atributos,nombres_columnas), filename: "Elenco_lezioni-#{Date.today}.csv"
  end

  def editattendance
  end

  # GET /activities or /activities.json
  def index
    #@activities = Activity.order(:course_id, :activity_date, :name)
    # Organizar por el nombre dle curso, despuès por fecha de la actividad y después
    @activities = Activity.joins(activitycourses: [:course]).order('courses.name, activity_date, name')
    actualizar_campos_actividad
  end


  # Ver las actividades de un curso específico
  def activitycourse
    #@course = Course.find_by_id(params[:id])
    #@activities = @course.activities

    @course = Course.find_by_id(params[:id])
    @activitiescourse = Activitycourse.where(course:@course)
    @activities = Activity.where(id: @activitiescourse.pluck(:activity_id)).order(:activity_date, :name)
    actualizar_campos_actividad
  end

  def user_activities
    # Sólo ver actividades de este año, no las de años pasados
    @activities = Activity.where(acyear_id: $year.id)
    @futureactivities = Activity.where('activity_date >= ?', DateTime.now).where(acyear_id: $year.id).order(activity_date: :asc)
    @pastactivities = Activity.where('activity_date < ?', DateTime.now).where(acyear_id: $year.id).order(activity_date: :asc)
  end

  def user_courses
    # Sólo ver actividades futuras, no las pasadas
    @courses = Course.where(acyear_id: $year.id).order(:date, :name)
    @student = Student.find_by(user: current_user)
    @stays = Stay.where(acyear_id: $year.id, student_id: @student.id)
    @courseattendances = Courseattendance.where(student_id: @student.id, course_id: @courses.pluck(:id))
    @validcourseattendances = @courseattendances.joins(:course).where('courses.min_attendance <= perc_attendance')
    @validhours = @validcourseattendances.sum(:hours)
    @minhours = @student.min_hours_required
    @validattendance = @validhours / @minhours
  end

  def user_past_activities
    # Sólo ver actividades futuras, no las pasadas
    @activities = Activity.where('activity_date < ?', DateTime.now).order(:activity_date, :name)
    #@activities = Activity.order(:activity_date, :name)
    #@activities = current_user.activities
  end

  # crear el calendario
  def calendar
    @activities = Activity.all
  end

  # crear el calendario
  def user_calendar
    @activities = current_user.activities
  end

  # GET /activities/1 or /activities/1.json
  def show
    @anno = Acyear.find_by_id(@activity.acyear_id)
    @activitycourse = Activitycourse.find_by(activity_id:@activity.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @professorcourse = Professorcourse.where(course_id: @course.id)
    @professors = Professor.where(id: @professorcourse.pluck(:professor_id))
  end


  # Verificar si el usuario ya está inscrito en esta actividad (no la estoy usando pero por si necesitara esta lógica)
  def enrollment_exist
    @activity = Activity.find_by_id(params[:activity_id])
    @user = User.find_by_id(params[:user_id])
    @enrollment = Enrollment.where(user: @user, activity: @activity)
  end

  def enroll
    @activity = Activity.find_by_id(params[:activity_id])
    @enrollment = Enrollment.new(activity_id: params[:activity_id], user_id: params[:user_id])
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_back fallback_location: root_path, notice: "Ti sei iscritto alla lezione." }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def unenrroll
    user = User.find_by_id(params[:user_id])
    activity = user.activities.find_by_id(params[:activity_id])
    user.activities.delete(activity) if activity
    @activity = Activity.find_by_id(params[:activity_id])
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Non sei più iscritto alla lezione." }
    end
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
    @activitycourse = Activitycourse.find_by(activity_id:@activity.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @professorcourse = Professorcourse.where(course_id: @course.id)
    @professors = Professor.where(id: @professorcourse.pluck(:professor_id))
    @anno = Acyear.find_by_id(@activity.acyear_id)
  end

  # La hice yo, para poder duplicar las actividades
  def duplicate
   @old_record = Activity.find(params[:id])          # Guardar los atributos de la actividad que se quiere duplicar
   @activity = Activity.new(@old_record.attributes)   # Hacer una acividad nueva con los atributos de la vieja
   render :new                                       # Mostrarlo en el form de crear una nueva actividad
  end


  # POST /activities or /activities.json
  def create
    @activity = Activity.new(activity_params)
    #link_professors

    #@activity.total_enrollments = @activity.student_ids.count

    respond_to do |format|
      if @activity.save
        format.html { redirect_to activity_url(@activity), notice: "La lezione è stata creata correttamente." }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end


  def link_professors
    @course = Course.find_by_id(@activitycourse.course_id)
    @profesorescurso = Professorcourse.where(course_id: @course.id)
    @profesores = Professor.where(id: @profesorescurso.pluck(:professor_id))
    @profesores.order(:lastname, :name).each_with_index do |professor, index|
      @professoractivity = Professoractivity.find_by(activity_id: @activity.id, professor_id: professor.id)
      @professoractivity.update(present: true)
      @professoractivity.update(cost: 0)
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    # Desambiguar el tema del costo de los Profesores
    costos = params[:costs]
    professors_selected = params[:professors_selected]
    if @activity.update(activity_params)
      @activitycourse = Activitycourse.find_by(activity_id: @activity.id)
      @course = Course.find_by_id(@activitycourse.course_id)
      @profesorescurso = Professorcourse.where(course_id: @course.id)
      @profesores = Professor.where(id: @profesorescurso.pluck(:professor_id))
      @profesores.order(:lastname, :name).each_with_index do |professor, index|
        @professoractivity = Professoractivity.find_by(activity_id: @activity.id, professor_id: professor.id)
        @professoractivity.update(present: true)
        @professoractivity.update(cost: costos[index])
        if professors_selected[index] == "no"
          @professoractivity.update(present: false)
          @professoractivity.update(cost: 0)
        end
      end
    end

    respond_to do |format|
      if @activity.update(activity_params)
        #format.html { redirect_to params[:redirect_location], notice: "La lezione è stata aggiornata correttamente." }
        format.html { redirect_to activity_url(@activity), notice: "La lezione è stata aggiornata correttamente." }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    activitycourse = Activitycourse.find_by(activity_id: @activity.id)
    @course = Course.find_by_id(activitycourse.course_id)
    @activity.destroy
    @course.update_course_activities
    respond_to do |format|
      if !@activity
        format.html { redirect_to activities_url, alert: "La lezione è stata distrutta correttamente." }
        format.json { head :no_content }
      else
        format.html { redirect_to courses_path, notice: "Non si può cancellare l'unica lezione di una attività. Forse dovresti cancellare l'attività." }
      end
    end
  end

# OJO: hay que agregarle manualmente student_ids:[] en los strong params para que al editar la actividad se actualice también ese campo
# Debe ir con [] porque una actividad tiene varios estudiantes
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activity_params
      params.require(:activity).permit(:name, :description, :duration, :total_enrollments,
        :activity_date, :kind, :professor_fullname, :qualificator, :context, :cost, :confirmed_date,
        :professor_fullname, :total_attendances, :students_enrolled, :students_attendance, :subtitle,
        :acyear_id,
        :course_id,
        student_ids:[],
        professor_ids:[],
        user_ids:[],
      )
    end
end
