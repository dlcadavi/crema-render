# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#Student.create(name: "Sandra Mora", id_number: "LC45214", country_of_birth: "Colombia", city_of_birth: "Medellín", birthdate: "1983/01/12", program_level: "PhD",
#program_name: "Doctorado en Ingeniería de Sistemas", hosting_start_date: "2021/01/01", hosting_end_date: "2021/07/01", image_url: 'LCadavid.jpg')

#Activity.create(name: "Corso di inglese", description: "una descripción de la actividad curso de inglés", duration: 2.5)

# Así creo usuarios de una vez con el role. Pero es un problema porque crea conflictos al resetar las bases de datos.
#User.create(email: 'admin@gmail.com', name: 'Administrador', role_id: 1, password: 'adminadmin')
#User.create(email: 'estudiante@gmail.com', name: 'Administrador', role_id: 2, password: 'estudiante')


# Lógica para limpiar la base de datos:
# rails db:reset db:migrate
# rails roles_all

# Explicación:
# Cuando quiera limpiar mis bases de datos debo hacer:
# rails db:reset db:migrate
# Eso automáticamente ejecuta este seed, que debe crear usuarios sin el rol porque los roles aún no se crean, ellos se crean con rails roles_all.
# Así que en este seed debo crear usuarios SIN el rol. El rol está en el archivo one_off, que asigna los roles a estos usuarios una vez se crean los roles.
# Para asignar el rol, después de reset la base de datos debo ejecutar:
# rails roles_all
# Atención, porque deben ser compatibles estos dos archvivos respecto al email de los usuarios que estoy creando.

Acyear.create(name: '2021-2022', startdate: '2021/09/01', finaldate: '2022/08/31')
Acyear.create(name: '2022-2023', startdate: '2022/09/01', finaldate: '2023/08/31')
Acyear.create(name: '2023-2024', startdate: '2023/09/01', finaldate: '2024/08/31')
currentyear_id = 2
$year = Acyear.find_by_id(currentyear_id)


User.create(email: 'admin@gmail.com', name: 'Juanito', lastname: 'Alimaña', password: 'adminadmin')
User.create(email: 'paolo@gmail.com', name: 'Paolo', lastname: 'Carli', password: 'paolocarli')
User.create(email: 'estudiante1@gmail.com', name: 'Clark', lastname: 'Kent', password: 'estudiante')
User.create(email: 'estudiante2@gmail.com', name: 'Luisa', lastname: 'Lane', password: 'estudiante')
User.create(email: 'estudiante3@gmail.com', name: 'Dyana', lastname: 'Kroll', password: 'estudiante')
User.create(email: 'estudiante4@gmail.com', name: 'Mark', lastname: 'Monroe', password: 'estudiante')
User.create(email: 'direttore@collegiounibs.it', name: 'Carla', lastname: 'Bisleri', password: 'carlabisleri')

Student.find_by(email: 'estudiante1@gmail.com').update(id_number: '4391514', phone_number: '+5732147874', birthdate: '1985/03/25', country_of_birth: 'IT', gender: 'Studente')
Student.find_by(email: 'estudiante2@gmail.com').update(id_number: 'CE567765312', phone_number: '+316865232', birthdate: '1987/09/18', country_of_birth: 'UK', gender: 'Studentessa')
Student.find_by(email: 'estudiante3@gmail.com').update(id_number: '534TC6546', phone_number: '+35128572', birthdate: '1991/10/03', country_of_birth: 'US', gender: 'Studentessa')
Student.find_by(email: 'estudiante4@gmail.com').update(id_number: '69786563TRD', phone_number: '+1698532362', birthdate: '1988/01/22', country_of_birth: 'IR', gender: 'Studente')
#Student.create(name: 'Nombre 1', lastname: 'Apellido 1', user_id: 2, id_number: '58582',hosting_start_date: "2021/01/01", hosting_end_date: "2022/07/01", fee: 500)
#Student.create(name: 'Nombre 2', lastname: 'Apellido 2', user_id: 2, id_number: '2121',hosting_start_date: "2021/10/01", hosting_end_date: "2022/07/01", fee: 500)
#Student.create(name: 'Nombre 3', lastname: 'Apellido 3', user_id: 2, id_number: '0548CF2',hosting_start_date: "2021/08/04", hosting_end_date: "2022/09/15", fee: 500)

Activity.create(name: 'Cucina con Lucia', description: 'Cucina con Lucia nel Collegio', context: 'N', kind: '6',
  activity_date: "2022/09/21 18:00", duration: 1, confirmed_date: 1, cost: 250, acyear_id: 2)
Activity.create(name: 'Corso inglese lezione 3', description: 'Lezione 3 del corso', context: 'I', kind: '1',
  activity_date: "2022/09/23 09:00", duration: 2, confirmed_date: 0, cost: 320, acyear_id: 2)
Activity.create(name: 'Viaggio a Padova', description: 'Viaggio per conoscere una nuova cultura', context: 'N', kind: '3',
  activity_date: "2022/09/28 07:00", duration: 12, confirmed_date: 1, cost: 710, acyear_id: 2)

Guest.create(name: 'Juan Felipe', lastname: 'Parra', id_number: 'FR5865', birthdate: '1983/12/01',
  email: 'jfparra@itm.edu.co', phone_number: '+573215874545', university: 'ITM', gender: 'Uomo', country_of_birth: 'UK')
Guest.create(name: 'Laura Melissa', lastname: 'Valencia', id_number: 'CC68787', birthdate: '1985/19/07',
    email: 'lmelissaval@unal.edu.co', phone_number: '+5732158787', university: 'Universidad Nacional de Colombia', gender: 'Donna', country_of_birth: 'CO')

Professor.create(name: 'Lucia', lastname: 'Serrat', email: 'luciaserrat@gmail.com', phone_number: 3218257845, id_number: '357858T',
  qualification: 'expert in ABM simulation')
Professor.create(name: 'Teresa', lastname: 'Dangon', email: 'teresadang@gmail.com', phone_number: 3214579787, id_number: '78897784T',
  qualification: 'expert in Ruby on Rails')
Professor.create(name: 'Carlo', lastname: 'Moreno', email: 'carlomoreno@gmail.com', phone_number: 8154783224, id_number: 'EY654658',
  qualification: 'faculty director National University of Colombia')

##################
# Crear las relaciones
##################

# Stay: estudiantes con años
Stay.create(student_id: 3, acyear_id: currentyear_id, hosting_start_date: '2022/10/01', hosting_end_date: '2023/07/28',
  typology: 'Studente', year_enrollment: '1U', frame: '46', fee: 430, periodgrades: 25.5, cumulativegrades: 26,
  fee_reduction_request: true, firsttime: true)
Stay.create(student_id: 5, acyear_id: currentyear_id, hosting_start_date: '2022/09/05', hosting_end_date: '2023/08/15',
  typology: 'Studente', year_enrollment: '3T', frame: '46', fee: 320, periodgrades: 25.7, cumulativegrades: 26.8,
  fee_reduction_request: true, firsttime: false)
Stay.create(student_id: 5, acyear_id: 1, hosting_start_date: '2021/09/01', hosting_end_date: '2022/08/25',
  typology: 'Studente', year_enrollment: '2T', frame: '46', fee: 300, periodgrades: 26.4, cumulativegrades: 26.9,
  fee_reduction_request: true, firsttime: false)
Stay.create(student_id: 6, acyear_id: 2, hosting_start_date: '2022/09/03', hosting_end_date: '2023/07/06',
  typology: 'Studente', year_enrollment: '1T', frame: '46', fee: 400, periodgrades: 25.3, cumulativegrades: 24,
  fee_reduction_request: false, firsttime: false)

# Crear los programas

# Visit: guests con años
Visit.create(guest_id: 1, acyear_id: 2, hosting_start_date: '2022/09/03', hosting_end_date: '2023/07/06',fee: 400)
Visit.create(guest_id: 1, acyear_id: 1, hosting_start_date: '2021/11/01', hosting_end_date: '2021/12/08',fee: 350)
Visit.create(guest_id: 2, acyear_id: 2, hosting_start_date: '2023/02/15', hosting_end_date: '2023/08/04',fee: 520)

# ProfessorActivity: profesores con actividades
Professoractivity.create(professor_id: 1, activity_id: 1)
Professoractivity.create(professor_id: 2, activity_id: 2)
Professoractivity.create(professor_id: 3, activity_id: 2)

#Attendance.create(activity_id: 1, student_id: 3)
