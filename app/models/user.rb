class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Un usuario está asociado únicamente con un estudiante, y
  # Cuando se borra el usuario se borra también el estudiante
  has_one :student, dependent: :destroy
  before_create :build_student
  after_create :create_courseattendances_for_student
  accepts_nested_attributes_for :student

  # para que los usuarios se puedan matricular a las actividades
  has_many :enrollments, dependent: :destroy
  has_many :activities, through: :enrollments


  # Para que los usuarios tengan un roles
  belongs_to :role, optional: true

  # Para que cada usuario tenga el role default por defecto apenas se crea
  # https://www.youtube.com/watch?v=wbRDqZCchs0
  # after_create :set_default_role

  # Campos obligatorios
  validates :email, :name, :encrypted_password, presence: true

  # Que cada email sea único (parece que ya funciona pero no sé cómo, si dejo esto me sale dos veces el error)
  # validates :email, uniqueness: true


  # para las validaciones
  def admin?
    role.name == "Admin"
  end

  def student?
    role.name == "Student"
  end

  def viewer?
    role.name == "Viewer"
  end

  def editor?
    role.name == "Editor"
  end

  def create_courseattendances_for_student
    @student = Student.find_by(user_id: self.id)
    @courses = Course.all
    @courses.each do |course|
      @courseattendance = Courseattendance.where(course_id: course.id, student_id: @student.id)
      Courseattendance.create(course_id: course.id, student_id: @student.id, hours: 0, total_activities: 0, perc_attendance: 0)
    end
  end

  def display_fullname
    self.lastname + ' ' + self.name if self.lastname and self.name
  end

  private

  # Para que cada usuario tenga el role default por defecto cuando se crea
  # def set_default_role
  #  self.update(role_id: Role.find_by(code: 'default').id)
  # end

end
