class Professor < ApplicationRecord

  # Para poder agregar los profesores a los cursos con el join model: professorcourse
  has_many :professorcourses
  has_many :courses, through: :professorcourses


  # Para poder agregar los profesores a las actividades con el join model: professoractivity
  has_many :professoractivities, dependent: :destroy
  has_many :activities, through: :professoractivities

  after_save :update_hours_lectured, :update_activitiesname, :update_number_activities_lectured
  after_update :update_hours_lectured, :update_number_activities_lectured

  # Campos obligatorios
  validates :name, :id_number, presence: true

  # Que cada id sea único
  validates :id_number, uniqueness: true

  def display_fullname
    self.lastname + ' ' + self.name if self.lastname and self.name
  end

  def update_hours_lectured
    @professoractivities = Professoractivity.where(professor_id: self.id, present: true)
    @actividades = Activity.where(id: @professoractivities.pluck(:activity_id))
    self.update_column :hours_lectured, @actividades.pluck(:duration).sum
  end

  def update_activitiesname
    self.update_column :activitiesname, self.activities.collect(&:name).join('; ')
  end

  def update_number_activities_lectured
    @professoractivities = Professoractivity.where(professor_id: self.id, present: true)
    @actividades = Activity.where(id: @professoractivities.pluck(:activity_id))
    self.update_column :number_activities_lectured, @actividades.pluck(:id).count
    #self.update_column :number_activities_lectured, self.activity_ids.count
  end

end
