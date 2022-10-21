class ProfessorsController < ApplicationController
  before_action :set_professor, only: %i[ show edit update destroy set_contract descargar_contrato download_contratto_italiano]

  # Autorizaciones
  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update]
  before_action :authorize_admin, only: [:destroy]
  before_action :authorize_to_see, only: [:index, :show, :set_contract, :download_contratto_italiano, :professorsexport]

  # Exportar a excel información profesores
  def professorsexport
    if params[:acyear_filter] != ""
      @activities = Activity.where(acyear_id: params[:acyear_filter])
      @professoractivities = Professoractivity.where(activity_id: @activities.pluck(:id))
      @professors = Professor.where(id: @professoractivities.pluck(:professor_id)).order(:lastname, :name)
    else
      @professors = Professor.order(:lastname, :name)
      @professoractivities = Professoractivity.where(professor_id: @professors.pluck(:id))
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Anagrafica_formatori-#{Date.today}.csv"
      end
    end
  end

  # GET /professors or /professors.json
  def index
    @professors = Professor.order(:lastname, :name)
  end

  def set_contract
  end

  # Para exportar el contrato del professor a Word (italiano)
  def download_contratto_italiano
    # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario

    # Para saber si el archivo existe
    if File.exist?("#{Rails.root}/app/assets/templates/contract_professors_italian.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/contract_professors_italian.docx")
      #valor = 0
      # Sustituir texto conservando el formato
      @actividades = Activity.where(id:params[:activity_ids])
      @valor = @actividades.sum(:cost)
      @actividades.each do |activity|
        # Calcular el valor
        #valor = valor + activity.cost
        doc.tables.each do |table|
          first_row = table.rows.first
          # Copy last row and insert a new one before last row
          new_row = first_row.copy
          new_row.insert_after(table.rows.last)

          # Substitute text in each cell of this new row
          new_row.cells.each do |cell|
            cell.paragraphs.each do |paragraph|
              paragraph.each_text_run do |text|
                text.substitute('Argomento', activity.name.to_s)
                text.substitute('Data', activity.activity_date.to_date.strftime("%d/%m/%y"))
                text.substitute('Ore', activity.duration.to_s)
                text.substitute('Costo', activity.cost.to_s)
              end
            end
          end
        end
    end

      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @professor.name)
          tr.substitute('Cognome', @professor.lastname)
          tr.substitute('codicefiscale', @professor.id_number)
          tr.substitute('valoreuro', @valor.to_s)
          tr.substitute('valorparoleeuro', @valor.humanize)
        end
      end

      nombre_archivo = "ContrattoItaliano_professor_#{@professor.name}"
      guardar(doc,nombre_archivo)
    else
      respond_to do |format|
        format.html { redirect_to professors_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /professors/1 or /professors/1.json
  def show
  end

  # GET /professors/new
  def new
    @professor = Professor.new
  end

  # GET /professors/1/edit
  def edit
  end

  # POST /professors or /professors.json
  def create
    @professor = Professor.new(professor_params)
    respond_to do |format|
      if @professor.save
        format.html { redirect_to professor_url(@professor), notice: "Il professore è stato creato con successo." }
        format.json { render :show, status: :created, location: @professor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professors/1 or /professors/1.json
  def update
    respond_to do |format|
      if @professor.update(professor_params)
        format.html { redirect_to professor_url(@professor), notice: "Il professore è stato aggiornato con successo." }
        format.json { render :show, status: :see_other, location: @professor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professors/1 or /professors/1.json
  def destroy
    @professor.destroy

    respond_to do |format|
      format.html { redirect_to professors_url, status: :see_other, notice: "Il professore è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private

    # Guardar con otro nombre, descargar y borrar el documento
    def guardar(doc,nombre_archivo_contrato)
      ruta = "#{Rails.root}/app/assets/templates/"
      doc.save("#{ruta}#{nombre_archivo_contrato}.docx")

      # Para exportar a Word y que después se pueda borrar el archivo
      File.open(ruta+nombre_archivo_contrato+'.docx', 'r') do |f|
        send_data(f.read, filename: "#{nombre_archivo_contrato}.docx", type: "text/docx")
      end

      # Para borrarlo ya que lo exportó
      File.delete(ruta + "#{nombre_archivo_contrato}.docx")
    end

    # Use callbacks to share common setup or constraints between actions.

    def set_professor
      @professor = Professor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professor_params
      params.require(:professor).permit(:name, :lastname, :email, :phone_number, :qualification, :id_number,
        :activitiesname,
        activity_ids:[])
    end
end
