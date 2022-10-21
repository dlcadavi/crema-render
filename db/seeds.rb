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


User.create(email: 'admin@gmail.com', name: 'Paolo', lastname: 'Carli', password: 'adminadmin')
User.create(email: 'estudiante@gmail.com', name: 'Jane', lastname: 'Doe', password: 'estudiante')

Student.find_by(email: 'estudiante@gmail.com').update(id_number: 'CF123456', phone_number: '+5732147874', birthdate: '1985/03/25', country_of_birth: 'IT', gender: 'Studente')

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

# Crear los programas

# Visit: guests con años
Visit.create(guest_id: 1, acyear_id: 2, hosting_start_date: '2022/09/03', hosting_end_date: '2023/07/06',fee: 400)
Visit.create(guest_id: 1, acyear_id: 1, hosting_start_date: '2021/11/01', hosting_end_date: '2021/12/08',fee: 350)
Visit.create(guest_id: 2, acyear_id: 2, hosting_start_date: '2023/02/15', hosting_end_date: '2023/08/04',fee: 520)

# ProfessorActivity: profesores con actividades

#Attendance.create(activity_id: 1, student_id: 3)
