class Guest < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_one_attached :profile_picture

  after_save :set_update_attributes_visit
  after_update :set_update_attributes_visit

  def set_update_attributes_visit
    @visit = Visit.where(guest_id: self.id).order(:hosting_end_date).last
    if @visit
      @visit.set_months
      @visit.set_annualfee
    end
  end


  # Exportar a excel (método que creé yo)
  def self.to_csv(guests,attributes,nombres_columnas)
    CSV.generate(headers:true) do |csv|
      csv << nombres_columnas
      guests.each do |guest|                                 # el csv se va construyendo fila por fila (estudiante por estudiante)
        csv << guest.attributes.values_at(*attributes)
      end
    end
  end


  def display_fullname
    self.lastname + ' ' + self.name if self.lastname and self.name
  end

end
