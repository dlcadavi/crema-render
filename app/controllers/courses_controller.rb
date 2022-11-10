class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy calc_attendance]

  # Para asegurar que sólo usuarios registrados podrían ver esto


  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update, :editattendance]
  before_action :authorize_admin, only: [:destroy]
  # Los estudiantes NO ven el index pero pueden ver el show, porque en el show del curso se omite la información sensible (ej costo)
  before_action :authorize_to_see, only: [:index, :export_courses]


  # Exportar a excel los cursos para control del Collegio
  def export_courses
    @courses = Course.all
    @courses.each do |course|
      if params[:acyear_filter] != ""
        @courses = Course.where(acyear_id: params[:acyear_filter])
      else
        @courses = Course.order(:date, :name)
      end
      atributos =%w{ name description date duration numberactivities typology professor aggregated_qualification context min_attendance}              # acá se definen las columnas que quiero que vayan
      nombres_columnas = ["Argomento","Descrizione","Ore", "Data inizio", "Numero lezioni", "Tipo","Docente","Qualifica","Contesto", "Partecipazione minima %"]            # acá le doy el nombre a las columnas
      send_data @courses.to_csv(@courses,atributos,nombres_columnas), filename: "Elenco_Attivita-#{Date.today}.csv"
    end
  end

  # GET /courses or /courses.json
  def index
    @courses = Course.all.order(date: :asc)
  end

  # GET /courses/1 or /courses/1.json
  def show
    activities_id = Activitycourse.where(course_id: @course.id).pluck(:activity_id)
    @activities = Activity.where(id: activities_id)
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    activities_id = Activitycourse.where(course_id: @course.id).pluck(:activity_id)
    @activities = Activity.where(id: activities_id)
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.min_attendance = params[:course][:min_attendance].to_f/100   # actualizar número de actividades del curso

    # Crear las actividades (el nombre se construye acá)
    # capturar los datos que manda el form
    fechas = params[:activity_dates]
    fechas.delete("")  #limpiar fechas
    fechas_confirmadas = params[:confirmed_dates]
    duraciones = params[:durations]
    totalactividades = fechas.length()  # calcular número de actividades válidas del curso
    @course.numberactivities = totalactividades   # actualizar número de actividades del curso
    @profesores = params[:course][:professor_ids]
    @profesores.delete("")  #limpiar profesores id

    if totalactividades == 0
      redirect_to request.referer, alert: "Devi creare almeno una lezione per quest'attività"
    else

      # crear las actividades si el curso se guarda
      if @course.save
        fechas.each_with_index do |fecha, index|    # crear las actividades del curso, una por una
          nombre = params[:course][:name] + ' - lezione ' + (index + 1).to_s    # construir el nombres_columnas
          costo = params[:course][:cost].to_f / totalactividades    # calcular el costo

          # cuando las fechas confirmadas son todas no, no envía fechas confirmadas
          if fechas_confirmadas.nil?
            confirmada = false
          else
            confirmada = fechas_confirmadas[index]
          end

          activity = Activity.create(name: nombre, activity_date: fecha, confirmed_date: confirmada, duration: duraciones[index], cost: costo,
            description: params[:course][:description], context: params[:course][:context], kind: params[:course][:typology],
            professor_fullname: @course.professor,
            aggregated_qualification: @course.aggregated_qualification,
            )
          Activitycourse.create(activity_id: activity.id, course_id: @course.id)
          @profesores.each do |profesor|
            Professoractivity.create(activity_id:activity.id, professor_id: profesor, cost: '0', present: true)
          end
          activity.modify_attributes
        end
        @course.modify_attributes
      end

      respond_to do |format|
        if @course.save
          format.html { redirect_to course_url(@course), notice: "L'attività è stata creato con successo." }
          format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def update
    # modificar la min_attendance que ingresó el usuario
    params[:course][:min_attendance] = params[:course][:min_attendance].to_f/100
    fechas = params[:activity_dates]
    fechas.delete("")  #limpiar fechas
    duraciones = params[:durations]
    actividadesID = params[:activityID]
    costo = params[:course][:cost].to_f / fechas.length()    # calcular el costo
    @profesores = params[:course][:professor_ids]
    @profesores.delete("")  #limpiar profesores id


    # modificar las actividades asociadas con el curso
    if @course.update(course_params)
      # actualizar una por una las actividades que existen (o crearlas si no existen)
      fechas.each_with_index do |fecha, index|    # crear las actividades del curso, una por una
        @activity = Activity.find_by_id(actividadesID[index])
        # actualizar
        if @activity
          #fecha_actividad = DateTime.strptime(fecha, '%d/%m/%Y %H:%M')
          fechaconfirmada = true    # necesario porque en el form se ven como "sí y no"
          fechaconfirmada = false if params[:confirmed_dates][index]=="no"
          nombre = params[:course][:name] + ' - lezione ' + (index + 1).to_s    # construir el nombres_columnas
          @activity.update(name: nombre, activity_date: fecha, confirmed_date: fechaconfirmada, duration: duraciones[index], cost: costo,
            description: params[:course][:description], context: params[:course][:context], kind: params[:course][:typology],professor_fullname: @course.professor)
        else
        #crear actividades
          nombre = params[:course][:name] + ' - lezione ' + (index + 1).to_s    # construir el nombres_columnas
          @activity = Activity.create(name: nombre, activity_date: fecha, confirmed_date: params[:confirmed_dates][index], duration: duraciones[index], cost: costo,
            description: params[:course][:description], context: params[:course][:context], kind: params[:course][:typology],
            acyear_id: $year.id,
            #professor_fullname: @course.professor,
            aggregated_qualification: @course.aggregated_qualification)
          Activitycourse.create(activity_id: @activity.id, course_id:@course.id)
          @profesores.each do |profesor|
            Professoractivity.create(activity_id:@activity.id, professor_id: profesor, cost: '0', present: true)
          end
        end

        # Actualizar los profesores
        @profesoractivities = Professoractivity.where(activity_id:@activity.id)

        # eliminar las relaciones de los profesores con las actividades para los profesores que se eliminaron del curso
        @profesoractivities.each do |profesoractivity|
          profesor = Professor.find_by_id(profesoractivity.professor_id)
          #ver
          unless @profesores.include?(profesor.id.to_s)
            profesoractivity.destroy
            profesor.update_activitiesname
            profesor.update_number_activities_lectured
            profesor.update_hours_lectured
          end
        end
        # Crear las nuevas relaciones entre profesores y actividades si se agregaron nuevos profesores al curso
        @profesores.each do |profesor|
          profesoractivity = Professoractivity.where(activity_id:@activity.id, professor_id: profesor)
          Professoractivity.create(activity_id:@activity.id, professor_id: profesor, cost: '0', present: true) if profesoractivity.empty?
          professor = Professor.find_by_id(profesor)
          professor.update_activitiesname
          professor.update_number_activities_lectured
          professor.update_hours_lectured
        end


        #Borrar actividades, bendito...
        #actividades = Activitycourse.where(course_id: @course.id)
      end
    end
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "L'attivitàe le sue lezioni sono state aggiornati con successo." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /courses/1 or /courses/1.json
  def destroy
    # borrar primero las actividades asociadas al curso
    @activitycourses = Activitycourse.where(course_id: @course.id)
    @activities = Activity.where(id: @activitycourses.pluck(:activity_id))
    @course.update_column :deleteconfirmation, 1
    @activities.destroy_all
    #@activities.destroy_all_without_callbacks
    #@activities.each do |activity|
    #  activity.destroy_without_callbacks
    #end
    # borrar el curso
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "L'attivitàe le sue lezioni sono state distrutti con successo." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :context, :typology, :cost,
        :numberactivities, :aggregated_qualification, :professor,
        :min_attendance,
        #:activity_id,
        professor_ids:[],
    )
    end
end
