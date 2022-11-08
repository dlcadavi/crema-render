class Graduation < ApplicationRecord
  belongs_to :stay, optional: true
  belongs_to :program, optional: true

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
    programa = Program.find_by_id(self.program_id)
    self.update_column :tipo, programa.tipo
  end

end
