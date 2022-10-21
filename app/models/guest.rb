class Guest < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_one_attached :profile_picture

  #before_save :copy_attributes_from_visit
  #before_create :copy_attributes_from_visit

  # Exportar a excel (método que creé yo)
  def self.to_csv(guests,attributes,nombres_columnas)
    CSV.generate(headers:true) do |csv|
      csv << nombres_columnas
      guests.each do |guest|                                 # el csv se va construyendo fila por fila (estudiante por estudiante)
        csv << guest.attributes.values_at(*attributes)
      end
    end
  end


  def copy_attributes_from_visit
    #@stay = Stay.find_by(student_id: self.id, acyear_id: $year.id)
    @visit = Visit.where(guest_id: self.id).order(:hosting_end_date).last
    if @visit
      #Actualizar los atributos calculados de stay
      @visit.set_months
      @visit.set_annualfee

      self.update_column :fee, @visit.fee
      self.update_column :annualfee, @visit.annualfee
      self.update_column :hosting_start_date, @visit.hosting_start_date
      self.update_column :hosting_end_date, @visit.hosting_end_date
      self.update_column :months, @visit.months
    else
      self.update_column :fee, nil
      self.update_column :annualfee, nil
      self.update_column :hosting_start_date, nil
      self.update_column :hosting_end_date, nil
      self.update_column :months, nil
    end
  end

  def display_fullname
    self.lastname + ' ' + self.name if self.lastname and self.name 
  end

end
