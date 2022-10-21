# Creada por mì para asignar los roles del Devise
# Debo ejecutarlo desde consola con:
# rails roles_all
# cada vez que haga alguna actualización sobre los roles (nombres o nuevos roles o eliminar roles)
# https://www.youtube.com/watch?v=wbRDqZCchs0

# Los roles son un modelo en Crema
# Pero no vale la pena crearlos desde la app porque es una cosa muy estática, así que se crean desde consola.

# Lógica para limpiar la base de datos:
# rails db:reset db:migrate
# rails roles_all

#########################################################################################
# roles

desc "populate roles"
task :populate_roles => :environment do
  Role.where( code: 'admin').first_or_create.update(name: 'Admin')
  Role.where( code: 'student').first_or_create.update(name: 'Student')
  Role.where( code: 'viewer').first_or_create.update(name: 'Viewer')
  Role.where( code: 'editor').first_or_create.update(name: 'Editor')
end

desc "set default roles"
task :default_roles => :environment do
  admin = Role.find_by(code: 'admin')
  student = Role.find_by(code: 'student')

  #User.update_all(role_id: default.id)
  User.find_by(email: 'admin@gmail.com').update(role_id: admin.id)
  User.find_by(email: 'estudiante@gmail.com').update(role_id: student.id)
end

desc "role_tasks"
task :roles_all => [ :populate_roles, :default_roles ] do
  puts "Finished role tasks"
end

############################################################################################3
# actualizar profesores

task :update_professors => [:update_profesores] do
  puts "Finiseh update professors task"
end

task :update_profesores => :environment do
  professors = Professor.all
  professors.each do |profesor|
    profesor.update_activitiesname
    profesor.update_number_activities_lectured
    profesor.update_hours_lectured
  end
end

###############################################################################################
# actualizar stays

task :update_stays => [:update_estadias] do
  puts "Finiseh update stays task"
end

task :update_estadias => :environment do
  stays = Stay.all
  stays.each do |stay|
    stay.save
  end
end

###############################################################################################
# actualizar courses

task :update_courses => [:update_cursos] do
  puts "Finiseh update courses task"
end

task :update_cursos => :environment do
  courses = Course.all
  courses.each do |course|
    course.save
  end
end

###############################################################################################
# actualizar actividades

task :update_activities => [:update_actividades] do
  puts "Finiseh update activities task"
end

task :update_actividades => :environment do
  activities = Activity.all
  activities.each do |activity|
    activity.save
  end
end
