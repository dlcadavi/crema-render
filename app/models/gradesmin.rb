class Gradesmin < ApplicationRecord

  # Para poblar la tabla desde el csv
  def self.import(file)
#    CSV.foreach(file.path, headers: true) do |row|
#      Gradesmin.create! row.to_hash
#    end

    # Las creé yo para que automáticamente pase todos los números decimales de comas a puntos y puedan ser leídos como números por Rails
    comma_numbers = ->(s) {(s =~ /^\d+,/) ? (s.gsub(',' , '.').to_f) : s}
    CSV::Converters[:comma_numbers] = comma_numbers

    #CSV.foreach(file.path, headers: true, skip_blanks: true, converters: [:all, :comma_numbers]) do |row|
    CSV.foreach(file.path, headers: true, skip_blanks: true, converters: [:all, :comma_numbers]) do |row|
      area,year,grades = row
      @gradesmin = Gradesmin.find_by(area: area[1], year: year[1])
      # Si no existe el gradesmin, que lo cree
      if @gradesmin.nil?
        Gradesmin.create! row.to_hash
      # Si sí existe el gradesmin, que actualice el mínimo
      else
        @gradesmin.update_column :grades, grades[1]
      end
    end
  end
end
