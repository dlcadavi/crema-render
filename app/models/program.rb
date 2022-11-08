class Program < ApplicationRecord
  has_many :stays
  has_many :graduations

  after_save :update_stays

  def update_stays
    if self.id
      @stays = Stay.where(program_id: self.id)
      @students = Student.where(id:@stays.pluck(:student_id))
      @stays.each do |stay|
        stay.set_kind
      end
    end
  end

  # Para poblar la tabla desde el csv
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      @program = Program.find_by(code: row[0])
      if @program
        @program.update(name: row[1], area: row[2])
      else
        Program.create! row.to_hash
      end
    end
  end

end
