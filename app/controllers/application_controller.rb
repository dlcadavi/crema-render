class ApplicationController < ActionController::Base
  # Todo esto es para permitir que devise deje que el rol sea aceptado como uno de los paràmetros al signup

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_variables

  protected


  # Variables que son comunes a todos los métodos de este modelo (o sea, a todas las acciones que hay en este controlador)
  # Acá se define el año actual, current year
  #####################################


  def set_variables
    currentyear_id = 2
    $year = Acyear.find_by_id(currentyear_id)
    $anno_iscrizione_list = [ '1T','2T','3T','1U','2U','3U','4U','5U','6U','1S','2S','1D','2D','3D','FC' ]
    $room_list = [ '101','102','103','104','105','106','107','108','109','110','111','112',
      '201','202','203','204','205','206','207','208','209','210','211','212',
      '301','302','303','304','305','306','307','308','309','310','311','312']
    $typology_list = [
      '1. Orientamento al lavoro',
      '2. Aula (formazione frontale)',
      '3. Arti (musica, teatro, pittura, letteratura, cinema, etc.)',
      '4. Action learning',
      '5. Projet work',
      '6. Coaching',
      '7. Tutorship',
      '8. Study Tour',
      '9. Summer School',
      '10. Outdoor training',
      '11. E-learning',
      "12. Mobilità"
    ]
  end

  # Para definir quiénes son los usuarios autorizados a hacer ciertas cosas en toda la app
  # redirigen a la misma página donde están

  def authorize_to_edit
    redirect_to(request.referrer, :notice => "Utente non abilitato :(") and return unless (current_user.editor? or current_user.admin?)
  end

  def authorize_to_see
    redirect_to(root_path, :notice => "Utente non abilitato :(") and return unless (current_user.editor? or current_user.admin? or current_user.viewer?)
  end


  def authorize_admin
    redirect_to(request.referrer, :notice => "Utente non abilitato :(") and return unless current_user.admin?
  end

  def authorize_student
    redirect_to(request.referrer, :notice => "Utente non abilitato :(") and return unless current_user.student?
  end

  def authorize_viewer
    redirect_to(request.referrer, :notice => "Utente non abilitato :(") and return unless current_user.viewer?
  end

  def authorize_editor
    redirect_to(request.referrer, :notice => "Utente non abilitato :(") and return unless current_user.editor?
  end



  # Para definir quiénes son los usuarios autorizados a hacer ciertas cosas en toda la app
  def authorize_student0
    if !user_signed_in?
      redirect_to(root_path, :notice => "Utente non abilitato :(") and return
    else
      if current_user.role.name != "Student"
        redirect_to(root_path, :notice => "Deve essere un studente per fare questo.") and return
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:role_id, :name, :lastname, :role.name, student_attributes: :name] )
  end


end
