require "test_helper"

class StudentTest < ActiveSupport::TestCase

  # Para cargar los fixtures de estos tests, que son como los datos con los que se harán los tests
  # La tabla de productos se vacía y luego se carga con los datos que hay en fixtures, para hacerlo con ellos los Tests
  # Esa lìnea podría eliminarse porque rails por defecto carga todos los fixtures antes de hacer los tests, pero es bueno ponerla para acordarse
  fixtures :students

  # Test para verificar que sí se ingresna todos los atributos del estudiante
  test "student attributes must not be empty" do
    student = Student.new
    assert student.invalid?
    assert student.errors[:name].any?
    assert student.errors[:id_number].any?
    assert student.errors[:hosting_start_date].any?
  end

  # Hay que hacer un test para las fechas?

  # Test para validar que la imagen tenga la extensión correcta
  #def new_student(image_url)
  #  Student.new(
  #    name: "Un nombre cualquiera",
  #    id_number: "yyy",
  #    hosting_start_date: "2021-12-30",
  #    image_url: image_url
  #  )
  #end

  #test "image_url" do
  #  ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.JPG
  #            http://a.b.c/x/y/z/fred.gif        }
  #  bad = %w{ fred.doc fred.gif/more fred.gif.more}

    # En este loop se verifican los casos que esperamos que pasen la validación
  #  ok.each do |name|
  #    assert new_student(name).valid?, "#{name} shouldn't be invalid"
  #  end

    # En este loop se verifican los casos que esperamos que NO pasen la validación
  #  bad.each do |name|
  #    assert new_student(name).invalid?, "#{name} shouldn't be valid"
  #  end
  #end

  # Test para validar que los ids de los estudiantes sean únicos
  # students(:ruby).id_number trae el id_number para la línea llamada ruby en el fixtures de students,para hacer con ella este test de uniquidad, que debe salir inválido
  # porque se estaría tratando de guardar un estudiante nuevo con un id que ya tiene otro estudiante (el de la línea ruby, en fixtures) :)
  test "student is not valid without a unique id" do
    student = Student.new(
      name: "Un nombre cualquiera",
      id_number: students(:ruby).id_number,
      hosting_start_date: "2021-12-30",
      image_url: "fred.gif"
    )

    assert student.invalid?
    #se compara la respuesta contra la tabla de mensaje de errores (es algo de la internacionalización, boh...)
    assert_equal [I18n.translate('errors.messages.taken')],
                  student.errors[:id_number]
  end

  # test "the truth" do
  #   assert true
  # end
end
