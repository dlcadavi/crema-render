class Course < ApplicationRecord
  # Para poder agregar los profesores a los cursos con el join model: professorcourse
  has_many :professorcourses, dependent: :destroy
  has_many :professors, through: :professorcourses

  has_many :courseattendances, dependent: :destroy
  has_many :students, through: :courseattendances


  has_one :acyear

  # el curso pertenece a las actividades, porque cada actividad tiene un curso
  has_many :activitycourses, dependent: :destroy
  has_many :activities, through: :activitycourses

  after_save :create_courseattendances
  after_update :modify_attributes, :update_course_activities, :update_professors_attributes

  # Validaciones
  # validates :name, :id_number, :hosting_start_date, :hosting_end_date, :fee, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true
  validate :ensure_at_least_one_activity

  def ensure_at_least_one_activity
  end

  def update_professors_attributes
    actividades = Professoractivity.where(activity_id: self.id)
    @profesores = Professor.where(id: actividades.pluck(:professor_id))
    @profesores.each do |professor|
      professor.update_activitiesname
      professor.update_number_activities_lectured
      professor.update_hours_lectured
    end
  end


  def update_course_activities
    @actividades = Activity.where(id: Activitycourse.where(course_id: self.id).pluck(:activity_id))
    @actividades.order(:activity_date).each_with_index do |actividad, index|
      nombre = self.name + ' - lezione ' + (index + 1).to_s    # construir el nombres_columnas
      actividad.update_column :name, nombre
    end

  end

  def modify_attributes
    self.update_activities
    self.update_dates
    self.update_acyear
    self.update_duration
    self.update_cost
    self.update_professor_fullname
    self.update_typology
  end

  def update_typology
    @actividades = Activity.where(id: Activitycourse.where(course_id: self.id).pluck(:activity_id))
    suma_por_kind = @actividades.group(:kind).sum(:duration)
    maximo = suma_por_kind.key(suma_por_kind.values.max)
    self.update_column :typology, maximo
  end

  def update_activities
    @activities = Activitycourse.where(course_id: self.id)
    self.update_column :numberactivities, @activities.length
  end

  def update_duration
    @activities = Activitycourse.where(course_id: self.id)
    self.update_column :duration, @activities.pluck(:duration).sum
  end
  
  #revisar esta, candidata a modificarse
  def update_attendance_course
    @courseattendances = Courseattendance.where(course_id: self.id)
    @courseattendances.each do |courseattendance|
      student = Student.find_by_id(courseattendance.student_id)
      activities_id = Activitycourse.where(course_id: self.id).pluck(:activity_id)
      actividadescurso = Activity.where(id: activities_id)
      attendances = Attendance.where(student_id: student.id, activity_id: actividadescurso.pluck(:id))
      courseattendance.update_column :total_activities,  0
      courseattendance.update_column :hours,  0
      courseattendance.update_column :perc_attendance, 0
      if attendances.count > 0
        activities = Activity.where(id: attendances.pluck(:activity_id))
        courseattendance.update_column :total_activities,  activities.count if
        courseattendance.update_column :hours,  activities.pluck(:duration).sum
        courseattendance.update_column :perc_attendance, courseattendance.hours / self.duration
      end
    end
  end

  def create_courseattendances
    @students = Student.all
    @students.each do |student|
      #@stay = Stay.where(student_id: student.id, acyear_id: self.acyear_id)
      @courseattendance = Courseattendance.find_by(course_id: self.id, student_id: student.id)
      Courseattendance.create(course_id: self.id, student_id: student.id, hours: 0, total_activities: 0, perc_attendance: 0) if !@courseattendance
    end
  end

  def update_dates
    #aver
    activities_id = Activitycourse.where(course_id: self.id).pluck(:activity_id)
    @activities = Activity.where(id: activities_id)
    self.update_column :date, @activities.pluck(:activity_date).min
    self.update_column :end_date, @activities.pluck(:activity_date).max
  end

  def update_duration
    activities_id = Activitycourse.where(course_id: self.id).pluck(:activity_id)
    @activities = Activity.where(id: activities_id)
    self.update_column :duration, @activities.sum(:duration)
  end

  def update_cost
    activities_id = Activitycourse.where(course_id: self.id).pluck(:activity_id)
    @activities = Activity.where(id: activities_id)
    self.update_column :cost, @activities.sum(:cost)
  end

  def update_acyear
    #if self.activity_date.to_date < Date.new(2024,6,13)
    @acyear = Acyear.all
    @acyear.each do |acyear|
      #self.acyear_id = nil
      if self.date >= acyear.startdate and self.date <= acyear.finaldate
        self.update_column :acyear_id,  acyear.id
      end
      #hay que cuadrar un else acá para que permita guardar actividades sin año asignado
    end
  end

  def update_professor_fullname
    cursos = Professorcourse.where(course_id: self.id)
    @profesores = Professor.where(id: cursos.pluck(:professor_id))
    self.update_column :professor,  @profesores.collect(&:display_fullname).join(', ')
    self.update_column :aggregated_qualification, @profesores.collect(&:qualification).join(', ')
  end

  # Para exportar a excel
  def self.to_csv(courses,attributes,nombres_columnas)
    CSV.generate(headers:true) do |csv|
      csv << nombres_columnas
      courses.each do |course|
        # Necesario para que la fecha exporte como fecha sin hora, grrrr
        attr_values = attributes.map do |attr|
          attr_value = course.send(attr)
          attr_value = attr_value.to_date.strftime("%d/%m/%y") if attr == "date"
          attr_value
        end
        csv << attr_values
      end
    end
  end

end
