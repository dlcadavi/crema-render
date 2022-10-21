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
    #$classe_list =
    #[      "L-01 Beni culturali","L-02 Biotecnologie","L-03 Discipline delle arti figurative, della musica, dello spettacolo e della moda","L-04 Disegno industriale","L-05 Filosofia","L-06 Geografia","L-07 Ingegneria civile e ambientale","L-08 Ingegneria dell'informazione","L-09 Ingegneria industriale","L-10 Lettere","L-11 Lingue e culture moderne","L-12 Mediazione linguistica","L-13 Scienze biologiche","L-14 Scienze dei servizi giuridici","L-15 Scienze del turismo","L-16 Scienze dell'amministrazione e dell'organizzazione","L-17 Scienze dell'architettura","L-18 Scienze dell'economia e della gestione aziendale","L-19 Scienze dell'educazione e della formazione","L-20 Scienze della comunicazione","L-21 Scienze della pianificazione territoriale, urbanistica, paesaggistica e ambientale","L-22 Scienze delle attività motorie e sportive","L-23 Scienze e tecniche dell'edilizia","L-24 Scienze e tecniche psicologiche","L-25 Scienze e tecnologie agrarie e forestali","L-26 Scienze e tecnologie agro-alimentari","L-27 Scienze e tecnologie chimiche","L-28 Scienze e tecnologie della navigazione","L-29 Scienze e tecnologie farmaceutiche","L-30 Scienze e tecnologie fisiche","L-31 Scienze e tecnologie informatiche","L-32 Scienze e tecnologie per l'ambiente e la natura","L-33 Scienze economiche","L-34 Scienze geologiche","L-35 Scienze matematiche","L-36 Scienze politiche e delle relazioni internazionali","L-37 Scienze sociali per la cooperazione, lo sviluppo e la pace","L-38 Scienze zootecniche e tecnologie delle produzioni animali","L-39 Servizio sociale","L-40 Sociologia","L-41 Statistica","L-42 Storia","L-43 Tecnologie per la conservazione e il restauro dei beni culturali","LM-01 Antropologia culturale ed etnologia","LM-02 Archeologia","LM-03 Architettura del paesaggio","LM-04 Architettura e ingegneria edile-architettura","LM-05 Archivistica e biblioteconomia","LM-06 Biologia","LM-07 Biologie agrarie","LM-08 Biotecnologie industriali","LM-09 Biotecnologie mediche, veterinarie e farmaceutiche","LM-10 Conservazione dei beni architettonici e ambientali","LM-11 Conservazione e restauro dei beni culturali","LM-12 Design","LM-13 Farmacia e farmacia industriale","LM-14 Filologia moderna - Filologia moderna","LM-14 Filologia moderna - Lingua e cultura italiana","LM-15 Filologia, letterature e storia dell'antichità","LM-16 Finanza","LM-17 Fisica","LM-18 Informatica","LM-19 Informazione e sistemi editoriali","LM-20 Ingegneria aerospaziale e astronautica","LM-21 Ingegneria biomedica","LM-22 Ingegneria chimica","LM-23 Ingegneria civile","LM-24 Ingegneria dei sistemi edilizi","LM-25 Ingegneria dell'automazione","LM-26 Ingegneria della sicurezza","LM-27 Ingegneria delle telecomunicazioni","LM-28 Ingegneria elettrica","LM-29 Ingegneria elettronica","LM-30 Ingegneria energetica e nucleare","LM-31 Ingegneria gestionale","LM-32 Ingegneria informatica","LM-33 Ingegneria meccanica","LM-34 Ingegneria navale","LM-35 Ingegneria per l'ambiente e il territorio","LM-36 Lingue e letterature dell'Africa e dell'Asia","LM-37 Lingue e letterature moderne europee e americane","LM-38 Lingue moderne per la comunicazione e la cooperazione","LM-39 Linguistica","LM-40 Matematica","LM-41 Medicina e chirurgia","LM-42 Medicina veterinaria","LM-43 Metodologie informatiche per le discipline umanistiche","LM-44 Modellistica matematico-fisica per l'ingegneria","LM-45 Musicologia e beni culturali","LM-46 Odontoiatria e protesi dentaria","LM-47 Organizzazione e gestione dei servizi per lo sport e le attivitàmotorie","LM-48 Pianificazione territoriale urbanistica e ambientale","LM-49 Progettazione e gestione dei sistemi turistici","LM-50 Programmazione e gestione dei servizi educativi","LM-51 Psicologia","LM-52 Relazioni internazionali","LM-53 Scienza e ingegneria dei materiali","LM-54 Scienze chimiche","LM-55 Scienze cognitive","LM-56 Scienze dell'economia","LM-57 Scienze dell'educazione degli adulti e della formazione continua","LM-58 Scienze dell'universo","LM-59 Scienze della comunicazione pubblica, d'impresa e pubblicità - Scienze della comunicazione sociale e istituzionale","LM-59 Scienze della comunicazione pubblica, d'impresa e pubblicità - Pubblicità e comunicazione d'impresa","LM-60 Scienze della natura","LM-61 Scienze della nutrizione umana","LM-62 Scienze della politica","LM-63 Scienze delle pubbliche amministrazioni","LM-64 Scienze delle religioni","LM-65 Scienze dello spettacolo e produzione multimediale","LM-66 Sicurezza informatica","LM-67 Scienze e tecniche delle attività motorie preventive e adattate","LM-68 Scienze e tecniche dello sport","LM-69 Scienze e tecnologie agrarie","LM-70 Scienze e tecnologie alimentari","LM-71 Scienze e tecnologie della chimica industriale","LM-72 Scienze e tecnologie della navigazione (80/M)","LM-73 Scienze e tecnologie forestali ed ambientali","LM-74 Scienze e tecnologie geologiche","LM-75 Scienze e tecnologie per l'ambiente e il territorio","LM-76 Scienze economiche per l'ambiente e la cultura","LM-77 Scienze economico-aziendali","LM-78 Scienze filosofiche - Filosofia e storia della scienza","LM-78 Scienze filosofiche - Filosofia teoretica, morale, politica ed estetica","LM-78 Scienze filosofiche - Storia della filosofia","LM-79 Scienze geofisiche","LM-80 Scienze geografiche","LM-81 Scienze per la cooperazione allo sviluppo","LM-82 Scienze statistiche - Metodi per l'analisi valutativa dei sistemi complessi","LM-82 Scienze statistiche - Statistica demografica e sociale","LM-82 Scienze statistiche - Statistica per la ricerca sperimentale","LM-83 Scienze statistiche attuariali e finanziarie","LM-84 Scienze storiche - Storia antica","LM-84 Scienze storiche - Storia contemporanea","LM-84 Scienze storiche - Storia medievale","LM-84 Scienze storiche - Storia moderna","LM-85 Scienze pedagogiche","LM-86 Scienze zootecniche e tecnologie animali","LM-87 Servizio sociale e politiche sociali","LM-88 Sociologia e ricerca sociale - Metodi per la ricerca empirica nelle scienze sociali","LM-88 Sociologia e ricerca sociale - Sociologia","LM-89 Storia dell'arte","LM-90 Studi europei","LM-91 Tecniche e metodi per la società dell'informazione","LM-92 Teorie della comunicazione","LM-93 Teorie e metodologie dell'e-learning e della media education","LM-94 Traduzione specialistica e interpretariato - Interpretariato di conferenza","LM-94 Traduzione specialistica e interpretariato - Traduzione letteraria e in traduzione tecnico-scientifica","LMG/01 Giurisprudenza - Scienze Giuridiche","LMG/01 Giurisprudenza - Giurisprudenza","LMG/01 Giurisprudenza - Teoria e tecniche della normazione e dell'informazione giuridica",
    #]
  end

  # Para definir quiénes son los usuarios autorizados a hacer ciertas cosas en toda la app
  def authorize_admin
    if !user_signed_in?
      redirect_to(root_path, :notice => "Utente non autorizato :(") and return
    else
      if current_user.role.name != "Admin"
        redirect_to(root_path, :notice => "Utente non autorizato :(") and return
      end
    end
  end

  # Para definir quiénes son los usuarios autorizados a hacer ciertas cosas en toda la app
  def authorize_student
    if !user_signed_in?
      redirect_to(root_path, :notice => "Utente non autorizato :(") and return
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
