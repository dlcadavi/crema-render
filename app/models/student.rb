class Student < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :activities, through: :attendances

  has_many :courseattendances, dependent: :destroy
  has_many :courses, through: :courseattendances

  has_one_attached :profile_picture
  belongs_to :user

  has_many :stays, dependent: :destroy
  has_many :acyears, through: :stays

  before_save :set_from_user
  before_create :set_from_user



  # Campos obligatorios (no es necesario porque ahora se crean desde los usuarios??)
  # validates :name, :id_number, :hosting_start_date, :hosting_end_date, :fee, presence: true
  # validates :id_number, uniqueness: true

  validates :id_number,
    uniqueness: {
      message: ->(object, data) do
        "Il codice fiscale #{data[:value]} è già in uso per otro studente"
      end
    }

  # Imagen en extensión vàlida (yo defino cuáles extensiones son válidas)
  #validates :image_url, allow_blank: true, format: {
  #  with: %r{\.(gif|jpg|png|jpeg)\Z}i,
  #  message: 'must be a URL for .gif, .jpg, .jpeg, .png image'
  #}

  def self.search(search)
    if search
      criterio = "%#{search}%"
      where("concat_ws(' ',name, lastname, gender) ILIKE ?", criterio).to_a
      #debug
    else
      find(:all)
    end
  end


  def self.search0(search)
    if search
      criterio = "%#{search}%"
      where("name ILIKE ? or lastname ILIKE ?", criterio, criterio).to_a
      #debug
    else
      find(:all)
    end
  end

  def copy_attributes_from_stay
  end

  def copy_attributes_from_stay0
    #@stay = Stay.find_by(student_id: self.id, acyear_id: $year.id)
    @stay = Stay.where(student_id: self.id, acyear_id: $year.id).order(:hosting_end_date).last
    if @stay
      #Actualizar los atributos calculados de stay
      @stay.calc_number_activities_attended
      @stay.calc_hours_attended
      @stay.update_attendance_status
      @stay.update_periodgrades_status
      @stay.update_cumulativegrades_status

      self.update_column :year_enrollment, @stay.year_enrollment
      self.update_column :fee, @stay.fee
      self.update_column :annualfee, @stay.annualfee
      self.update_column :hosting_start_date, @stay.hosting_start_date
      self.update_column :hosting_end_date, @stay.hosting_end_date
      self.update_column :months, @stay.months
      self.update_column :fee_reduction_request, @stay.fee_reduction_request
      self.update_column :typology, @stay.typology
      self.update_column :frame, @stay.frame
      self.update_column :number_activities_attended, @stay.number_activities_attended
      self.update_column :hours_attended, @stay.hours_attended
      self.update_column :periodgrades, @stay.periodgrades
      self.update_column :cumulativegrades, @stay.cumulativegrades
      self.update_column :attendance_status, @stay.attendance_status
      self.update_column :periodgrades_status, @stay.periodgrades_status
      self.update_column :cumulativegrades_status, @stay.cumulativegrades_status
      self.update_column :kind, @stay.kind
      self.update_column :gradesmin, @stay.gradesmin
      self.update_column :perc_attendance, @stay.perc_attendance
      self.update_column :min_hours_required, @stay.min_hours_required
      self.update_column :kindcode, @stay.kindcode
      self.update_column :grant, @stay.grant
    else
      self.update_column :year_enrollment, nil
      self.update_column :fee, nil
      self.update_column :annualfee, nil
      self.update_column :hosting_start_date, nil
      self.update_column :hosting_end_date, nil
      self.update_column :months, nil
      self.update_column :fee_reduction_request, nil
      self.update_column :typology, nil
      self.update_column :frame, nil
      self.update_column :number_activities_attended, nil
      self.update_column :hours_attended, nil
      self.update_column :periodgrades, nil
      self.update_column :cumulativegrades, nil
      self.update_column :attendance_status, nil
      self.update_column :periodgrades_status, nil
      self.update_column :cumulativegrades_status, nil
      self.update_column :kind, nil
      self.update_column :gradesmin, nil
      self.update_column :perc_attendance, nil
      self.update_column :min_hours_required, nil
      self.update_column :kindcode, nil
      self.update_column :grant, nil
    end
  end

  def display_fullname
    self.lastname + ' ' + self.name if self.lastname and self.name
  end

  def set_from_user
    self.name = self.user.name
    self.lastname = self.user.lastname
    self.email = self.user.email
  end


  # Exportar a excel (método que creé yo)
  def self.to_csv(students,attributes,nombres_columnas)
    CSV.generate(headers:true) do |csv|
      csv << nombres_columnas
      students.each do |student|                                 # el csv se va construyendo fila por fila (estudiante por estudiante)
        # Necesario para que la fecha exporte como fecha sin hora, grrrr
        attr_values = attributes.map do |attr|
          attr_value = student.send(attr)
          attr_value = attr_value.to_date.strftime("%d/%m/%y") if (attr == "birthdate" or attr == 'hosting_start_date' or attr=='hosting_end_date') and attr_value
          attr_value
        end
        csv << attr_values
      end
    end
  end



end
