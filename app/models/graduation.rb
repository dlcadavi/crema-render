class Graduation < ApplicationRecord
  belongs_to :stay, optional: true

  #validates :id_number,
  #  uniqueness: {
  #    message: ->(object, data) do
  #      "Il codice fiscale #{data[:value]} è già in uso per otro studente"
  #    end
  #  }

  validates :stay_id, presence: true

  after_create :set_tipo
  after_save :set_tipo

  #private: no lo puedo usar porque el controlador stays invoca este método para actualizar el campo tipo de la graduación cuando cambia el stay

  def set_tipo
    stay = Stay.find_by_id(self.stay_id)
    segundo_caracter = stay.year_enrollment[1,1]
    if segundo_caracter == 'T' then self.update_column :tipo, "triennale" end
    if segundo_caracter == 'S' then self.update_column :tipo, "magistrale" end
    if segundo_caracter == 'U' then self.update_column :tipo, "ciclo unico" end
  end

end
