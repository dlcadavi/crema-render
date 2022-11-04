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
    CSV.generate(headers:true, col_sep: ';') do |csv|
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
