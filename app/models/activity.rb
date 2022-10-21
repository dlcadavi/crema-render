class Activity < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :students, through: :attendances

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments

  has_one :acyear

  # Para poder agregar los profesores a las actividades con el join model: professoractivity
  has_many :professoractivities, dependent: :destroy
  has_many :professors, through: :professoractivities

  #  no tiene el dependent:destroy acá porque tengo que ejercutar algunas cosas antes de borrar el activitycourses
  # Así que el activitycourses lo elimino manualmente en activitycourse.destroy
  #has_many :activitycourses, dependent: :destroy
  has_many :activitycourses, dependent: :destroy
  has_many :courses, through: :activitycourses

  after_save :set_acyear
  after_commit :update_professors_attributes, on: :create, on: :update
  after_update :update_attendance_course, :update_stay_perc_attendance, :update_cost, :update_course_typology, :update_course_duration
  before_destroy :check_before_removing!, prepend: true
  after_destroy :destroy_professoractivities

  # Campos obligatorios
  #validates :name, :activity_date, :duration, presence: true

  # Que cada nombre sea único (pero el nombre puede ser el mismo que otro si la fecha es distinta
  #validates :name, uniqueness: { scope: :activity_date }

  # estas rutinas no se pueden poner en el after_save porque requieren el Professoractivity y aún no se han creado cuando uno hace after save o after commit
  def modify_attributes
    self.set_professor_fullname
    self.update_aggregated_qualification
    self.update_professors_attributes
  end


  def destroy_professoractivities
    professoractivities = Professoractivity.where(activity_id: self.id)
    @profesores = Professor.where(id: professoractivities.pluck(:professor_id))
    professoractivities.destroy_all
    update_prof
  end


  def update_prof
    @profesores.each do |professor|
      professor.update_activitiesname
      professor.update_number_activities_lectured
      professor.update_hours_lectured
    end
  end

  def update_professors_attributes
    professoractivities = Professoractivity.where(activity_id: self.id)
    @profesores = Professor.where(id: professoractivities.pluck(:professor_id))
    update_prof
  end

  def update_course_duration
    @activitycourse = Activitycourse.find_by(activity_id: self.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @course.update_duration
  end


  def update_course_typology
    @activitycourse = Activitycourse.find_by(activity_id: self.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @course.update_typology
  end

  def update_cost
    @professoractivities = Professoractivity.where(activity_id: self.id)
    self.update_column :cost, @professoractivities.sum(:cost)
    update_course_cost
  end

  def update_course_cost
    @activitycourse = Activitycourse.find_by(activity_id: self.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @course.update_cost
  end

  def update_aggregated_qualification
    actividades = Professoractivity.where(activity_id: self.id)
    @profesores = Professor.where(id: actividades.pluck(:professor_id))
    self.update_column :aggregated_qualification, @profesores.collect(&:qualification).join(', ')
  end


  def set_professor_fullname
    actividades = Professoractivity.where(activity_id: self.id)
    @profesores = Professor.where(id: actividades.pluck(:professor_id))
    self.update_column :professor_fullname,  @profesores.collect(&:display_fullname).join(', ')
  end

  def check_before_removing!
    @activitycourse = Activitycourse.find_by(activity_id: self.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @actividadesdelcurso = Activitycourse.where(course_id: @course.id)
    numerodeact = @actividadesdelcurso.count
    if numerodeact == 1 and @course.deleteconfirmation == 0
      #errors.add(:base, "Cannot delete booking with payments")
      throw(:abort)
    else
      update_attributes_course
    end
  end

  def update_attributes_course
    activitycourse = Activitycourse.find_by(activity_id: self.id)
    @course = Course.find_by_id(activitycourse.course_id)
    @actividades = Activity.where(id: Activitycourse.where(course_id: @course.id).pluck(:activity_id))
    @course.update_column :numberactivities, @actividades.count-1
    @actividades.each do |actividad|
      if @course.cost and @course.numberactivities > 0
        actividad.update_column :cost, @course.cost / @course.numberactivities
      end
    end
    activitycourse.destroy
  end


  def update_stay_perc_attendance
    @activitycourse = Activitycourse.find_by(activity_id:self.id)
    @course = Course.find_by(id: @activitycourse.course_id)
    @courseattendances = Courseattendance.where(course_id: @course.id)
    @students=Student.where(id: @courseattendances.pluck(:student_id))
    @stays = Stay.where(student_id:@students.pluck(:id))
    @stays.each do |stay|
      stay.update_attendance_status
    end
  end

  # actualizar las asistencias a los cursos
  def update_attendance_course
    @activitycourse = Activitycourse.find_by(activity_id:self.id)
    @course = Course.find_by_id(@activitycourse.course_id)
    @course.update_attendance_course
  end


  def date_sin_hora
    self.activity_date.to_date
  end

  def calc_enrollment_and_attendance
    self.update_column :total_enrollments, self.users.count
    self.update_column :total_attendances, self.students.count

    actividades = Attendance.where(activity_id: self.id)
    @students = Student.where(id: actividades.pluck(:student_id))
    self.update_column :students_attendance, @students.collect(&:display_fullname).join(', ')

    actividades = Enrollment.where(activity_id: self.id)
    @users = User.where(id: actividades.pluck(:user_id))
    self.update_column :students_enrolled, @users.collect(&:display_fullname).join(', ')
  end

  def set_acyear
    @acyear = Acyear.all
    @acyear.each do |acyear|
      #self.acyear_id = nil
      if self.activity_date >= acyear.startdate and self.activity_date <= acyear.finaldate
        self.update_column :acyear_id, acyear.id
      end
      #hay que cuadrar un else acá para que permita guardar actividades sin año asignado
    end
  end

  # Para exportar a excel
  def self.to_csv(activities,attributes,nombres_columnas)
    CSV.generate(headers:true) do |csv|
      csv << nombres_columnas
      activities.each do |activity|
        # Necesario para que la fecha exporte como fecha sin hora, grrrr
        attr_values = attributes.map do |attr|
          attr_value = activity.send(attr)
          attr_value = attr_value.to_date.strftime("%d/%m/%y") if attr == "activity_date"
          attr_value
        end
        csv << attr_values
      end
    end
  end

end
