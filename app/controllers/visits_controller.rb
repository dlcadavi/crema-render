class VisitsController < ApplicationController
  before_action :set_visit, only: %i[ show edit update destroy downloadcontractitalian downloadcontractenglish]
  before_action :actualizar_campos_visita, only: %i[ show index downloadcontractitalian downloadcontractenglish]
  before_action :authorize_admin


  # Para exportar las visitas
  def visitsexport
    if params[:acyear_filter] != ""
      @visits = Visit.where(acyear_id: params[:acyear_filter])
      @guests = Guest.where(id: @visits.pluck(:guest_id))
      @acyearid = params[:acyear_filter]
      annoname = Acyear.find_by(id: @acyearid).name
    else
      @visits = Visit.all
      @guests = Guest.where(id: @visits.pluck(:guest_id))
      @acyearid = Acyear.all.pluck(:id)
      annoname = 'tutti gli anni'
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Visite-Anno#{annoname}-Consulta#{Date.today}.csv"
      end
    end
  end

  # Para exportar el contrato del estudiante a Word (italiano)
  # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario
  def downloadcontractitalian
    # Para saber si el archivo existe
    if File.exist?("#{Rails.root}/app/assets/templates/contract_italian.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/contract_italian.docx")
      @guest = Guest.find_by(id: @visit.guest_id)
      @year = Acyear.find_by(id: @visit.acyear_id)
      # Sustituir texto conservando el formato
      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @guest.name)
          tr.substitute('Cognome', @guest.lastname)
          tr.substitute('*rettamensile*', @visit.fee.to_s) if @visit.fee?
          tr.substitute('*rettamensileparole*', @visit.fee.humanize) if @visit.fee?
          tr.substitute('*rettacomplessa*', @visit.annualfee.to_s) if @visit.annualfee?
          tr.substitute('*rettacomplessaparole*', @visit.annualfee.humanize) if @visit.annualfee?
          tr.substitute('datainizio', @visit.hosting_start_date.strftime("%d/%m/%Y").to_s) if @visit.hosting_start_date?
          tr.substitute('datafine', @visit.hosting_end_date.strftime("%d/%m/%Y").to_s) if @visit.hosting_end_date?
          tr.substitute('*mesi*', @visit.months.to_s) if @visit.months?
        end
      end

      # Remove paragraphs
      doc.paragraphs.each do |p|
        p.remove! if p.to_s =~ /Nuovo ingresso anno 2022-23, a seguito della firma del “Contratto di ospitalità”/
      end
      doc.paragraphs.each do |p|
        p.remove! if p.to_s =~ /Permanenza confermata, rinnovo retta per l’anno 2022-23/
      end
      doc.paragraphs.each do |p|
        p.remove! if p.to_s =~ /esaminata e accolta la Sua domanda di riduzione della retta/
      end
      doc.paragraphs.each do |p|
        #p.remove! if p.to_s =~ /dottoranda(o) dell \' Universita degli Studi di Brescia/
        p.remove! if p.to_s == "beneficiaria(o) della Borsa di studio INPS"
      end
      doc.paragraphs.each do |p|
        #p.remove! if p.to_s =~ /dottoranda(o) dell \' Universita degli Studi di Brescia/
        p.remove! if p.to_s == "dottoranda/o dell'Università degli Studi di Brescia"
      end

      nombre_archivo_contrato = "Contratto_italiano_#{@guest.lastname+'_'+@guest.name+'_'+@year.name}"
      guardar(doc,nombre_archivo_contrato)
      #ruta = "#{Rails.root}/app/assets/templates/"
      #doc.save("#{ruta}#{nombre_archivo_contrato}.docx")
    else
      respond_to do |format|
        format.html { redirect_to students_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # Guardar con otro nombre, descargar y borrar el documento
  def guardar(doc,nombre_archivo_contrato)
    ruta = "#{Rails.root}/app/assets/templates/"
    doc.save("#{ruta}#{nombre_archivo_contrato}.docx")

    # Esto es para exportar a Word y que después se pueda borrar el archivo
    File.open(ruta+nombre_archivo_contrato+'.docx', 'r') do |f|
      send_data(f.read, filename: "#{nombre_archivo_contrato}.docx", type: "text/docx")
    end

    # Para borrarlo ya que lo exportó
    File.delete(ruta + "#{nombre_archivo_contrato}.docx")

  end


  def actualizar_campos_visita
    Visit.all.each do |visit|
      visit.set_months
      visit.set_annualfee
    end
  end


  def visitguest
    @guest = Guest.find_by_id(params[:id])
    @visits = @guest.visits
  end

  # GET /visits or /visits.json
  def index
    @visits = Visit.all.order(:hosting_start_date)
  end

  # GET /visits/1 or /visits/1.json
  def show
  end

  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
  end

  # POST /visits or /stvisitsays.json
  def create
    @visit = Visit.new(visit_params)
    @visit.guest_id = params[:visit][:guest_id]
    @visit.acyear_id = params[:acyear_id]
    #@stay = Stay.new(stay_params)
    respond_to do |format|
      if @visit.save
        format.html { redirect_to visit_url(@visit), notice: "La visita è stata creata con successo." }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1 or /visits/1.json

  def update
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to visit_url(@visit), notice: "La visita è stata aggiornata con successo." }
        format.json { render :show, status: :ok, location: @visit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1 or /visits/1.json
  def destroy
    @visit.destroy

    respond_to do |format|
      format.html { redirect_to visits_url, notice: "La visita è stata distrutta con successo." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def visit_params
      params.require(:visit).permit(:guest_id, :acyear_id, :hosting_start_date, :hosting_end_date, :fee, :annualfee, :description,
      )
    end
end
