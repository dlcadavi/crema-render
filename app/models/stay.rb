class Stay < ApplicationRecord
  belongs_to :student
  belongs_to :acyear
  has_one :graduation
  has_many :mobilities
  has_many :locations
  belongs_to :program, optional: true

  after_create :set_months, :set_fee, :set_annualfee, :set_monthsfee, :set_kind, :set_min_hours_required, :set_kindcode,
  :update_periodgrades_status, :update_attendance_status, :update_cumulativegrades_status, :update_student_fields
  after_save :set_months, :set_fee, :set_annualfee, :set_monthsfee, :set_kind, :set_min_hours_required, :set_kindcode,
  :update_periodgrades_status, :update_attendance_status, :update_cumulativegrades_status, :update_student_fields

  # Validaciones
  # Que cada combinación estudiante-año-fecha inicio sea única (porque puede haber varias estadías del mismo estudiante, varias del estudiante en un mismo año, pero no que empiecen todas el mismo día...)
  validates_uniqueness_of :student_id, scope: %i[acyear_id hosting_start_date]
  validates :hosting_start_date, presence: { message: 'Devi inserire la data inizio' }
  validates :hosting_end_date, presence: { message: 'Devi inserire la data fine' }
  # validar que la fecha de fin sea mayor que la fecha de inicio
  validates :hosting_end_date, comparison: { greater_than: :hosting_start_date, message: 'La data fine deve superare la data inizio' }


  def show_year
    Acyear.find_by_id(self.acyear_id).name
  end

  def show_year_with_dates
    Acyear.find_by_id(self.acyear_id).name + " (dal " + self.hosting_start_date.to_date.strftime("%d/%m/%y").to_s + " al " + self.hosting_end_date.to_date.strftime("%d/%m/%y").to_s + ")"

  end
  def update_student_fields
    @student = Student.find_by_id(self.student_id)
    @student.copy_attributes_from_stay
  end

  def set_kindcode
    codigo = Program.find_by_name(self.kind).code
    self.update_column :kindcode, codigo if codigo
  end

  def display_fullinfo
    self.kind + ' - anno: ' + self.year_enrollment if self.kind and self.year_enrollment
  end

  def set_min_hours_required
    # para cuando el year_enrollment sea FC
    self.update_column :min_hours_required, 1
    if self.typology == "D"
      self.update_column :min_hours_required, 25
    else
      anno = self.year_enrollment.chars.first
      if anno == '1'||anno == '2'||anno == '3' then self.update_column :min_hours_required, 70 end
      if anno == '4'||anno == '5'||anno == '6' then self.update_column :min_hours_required, 40 end
    end
    # proporcionarla
    if self.months < 6 then self.update_column :min_hours_required, self.min_hours_required * (self.months / 12) end
  end

  def set_months
    if self.hosting_end_date and self.hosting_start_date
      meses = ((self.hosting_end_date - self.hosting_start_date).to_f)/30
      self.update_column :months, (( meses * 2.0).round / 2.0)
    else
      self.update_column :months, nil
    end
  end

  def set_fee
    # el fee mensual es el fee de la primera location (para el contrato)
    @location = Location.where(stay_id: self.id).order(start_location_date: :asc).first
    self.update_column :fee, @location.fee if @location
  end

  def set_annualfee
    # sumar los fees de todos los locations
    @locations = Location.where(stay_id: self.id)
    self.update_column :annualfee, @locations.sum(:totalfee) if @locations
  end

  def set_monthsfee
    # sumar los meses que tienen fee
    @locations = Location.where(stay_id: self.id)
    self.update_column :monthsfee, @locations.sum(:months) if @locations
  end

  def set_kind
    if self.program_id?
      @prog_name = Program.find_by_id(program_id).name
      self.update_column :kind, @prog_name
    else
      self.update_column :kind, 'NA'
    end
  end

  # Capturar las notas mínimas exigidas por el ministerio
  def set_gradesmin
    self.update_column :gradesmin, 0
    if self.program_id?
      # capturar la nota mínima requerida por ministerio
      area = Program.find_by_id(self.program_id).area if self.program_id
      anno = self.year_enrollment.chars.first if self.year_enrollment
      @notaminima = 0
      @notaminima = Gradesmin.find_by(area: area, year:anno).grades if anno != "F"
      self.update_column :gradesmin, @notaminima
    end
  end

  # Calcular el estado según PeriodGrades
  def update_periodgrades_status
    set_gradesmin
    self.update_column :periodgrades_status, 'NA'
    if self.periodgrades? and self.gradesmin?
      if self.periodgrades < self.gradesmin*0.9 then self.update_column :periodgrades_status, 'insufficiente' end
      if self.periodgrades >= self.gradesmin*0.9 and self.periodgrades < self.gradesmin then self.update_column :periodgrades_status, 'buono' end
      if self.periodgrades >= self.gradesmin then self.update_column :periodgrades_status,'ottimo' end
    end
  end

  # Calcular el estado según CumulativeGrades
  def update_cumulativegrades_status
    set_gradesmin
    self.update_column :cumulativegrades_status, 'NA'
    if self.cumulativegrades? and self.gradesmin?
      if self.cumulativegrades < self.gradesmin*0.9 then self.update_column :cumulativegrades_status,'insufficiente' end
      if self.cumulativegrades >= self.gradesmin*0.9 and self.cumulativegrades < self.gradesmin then self.update_column :cumulativegrades_status, 'buono' end
      if self.cumulativegrades >= self.gradesmin then self.update_column :cumulativegrades_status,'ottimo' end
    end
  end


  # Calcular el estado según attendance
  def update_attendance_status
    calc_hours_attended
    if self.hosting_end_date? and self.hosting_start_date? and self.year_enrollment? then
      dias_stay = self.hosting_end_date - self.hosting_start_date.to_date
      dias_avance = Date.current - self.hosting_start_date
      porcentaje_avance_dias = dias_avance / dias_stay
      anno = self.year_enrollment.chars.first
    else
      porcentaje_avance_dias = 1
      anno = '1'
    end
    # Para el seed, presentación de la crema
    #total_horas = 15
    #dias_teoricos = 10
    #porcentaje_avance_dias = 0.9


    cumplimiento_attendances = (self.hours_attended.to_f / self.min_hours_required)
    self.update_column :perc_attendance, cumplimiento_attendances
    if cumplimiento_attendances < 0.9 then self.update_column :attendance_status, 'insufficiente' end
    if cumplimiento_attendances >= 0.9 and cumplimiento_attendances < 1 then self.update_column :attendance_status, 'buono' end
    if cumplimiento_attendances >= 1 then self.update_column :attendance_status, 'ottimo' end
  end

  def update_number_activities_attended
    @student = Student.find_by_id(self.student_id)
    @activities = @student.activities.where(acyear_id: self.acyear_id)
    self.update_column :number_activities_attended, @activities.count
  end

  def calc_hours_attended
    self.update_column :hours_attended, 0
    @student = Student.find_by_id(self.student_id)
    @activities = @student.activities.where(acyear_id: self.acyear_id)
    self.update_column :hours_attended, @activities.pluck(:duration).sum
  end


  private
  #def end_date_after_start_date
  #return if hosting_start_date.blank? || hosting_end_date.blank?

  #if hosting_end_date < hosting_start_date
  #  errors.add(:hosting_end_date, "La data fine deve essere superiore a la data d'inizio")
  #end

end
