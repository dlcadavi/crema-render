class StaysController < ApplicationController
  before_action :set_stay, only: %i[ show edit update destroy downloadcontractitalian downloadcontractenglish download_initial_libretto download_final_libretto studentactivities]
  before_action :actualizar_campos_stay, only: %i[ index downloadcontractitalian downloadcontractenglish download_initial_libretto download_final_libretto staystudent]
  before_action :authorize_admin

  def staystudent
    @student = Student.find_by_id(params[:id])
    @stays = @student.stays
  end

  def studentactivities
    @student = Student.find_by_id(@stay.student_id)
    @activities = @student.activities.where(acyear_id: @stay.acyear_id)
  end

  # Para exportar las estadías
  def staysexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @students = Student.where(id: @stays.pluck(:student_id))
      @acyearid = params[:acyear_filter]
      annoname = Acyear.find_by(id: @acyearid).name
    else
      @stays = Stay.all
      @students = Student.where(id: @stays.pluck(:student_id))
      @acyearid = Acyear.all.pluck(:id)
      annoname = 'Tutti'
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Soggiorni-Anno #{annoname}-Consulta#{Date.today}.csv"
      end
    end
  end

  def actualizar_campos_stay
    Stay.all.each do |stay|
      stay.set_months
      stay.set_annualfee
    end
  end

  # Para exportar el contrato del estudiante a Word (inglés)
  def downloadcontractenglish
    # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario
    if File.exist?("#{Rails.root}/app/assets/templates/contract_english.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/contract_english.docx")
      @student = Student.find_by(id: @stay.student_id)
      @year = Acyear.find_by(id: @stay.acyear_id)

      # Sustituir texto conservando el formato
      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @student.name)
          tr.substitute('Cognome', @student.lastname)
          tr.substitute('*rettamensile*', @stay.fee.to_s) if @stay.fee
          tr.substitute('datainizio', @stay.hosting_start_date.to_s) if @stay.hosting_start_date
          tr.substitute('datafine', @stay.hosting_end_date.to_s) if @stay.hosting_end_date
          tr.substitute('*rettamensileparole*', @stay.fee.humanize) if @stay.fee
          tr.substitute('*mesi*', @stay.months.to_s) if @stay.months
          tr.substitute('*rettacomplessa*', @stay.annualfee.to_s) if @stay.annualfee
          tr.substitute('*rettacomplessaparole*', @stay.annualfee.humanize) if @stay.annualfee
        end
      end

      nombre_archivo_contrato = "Contratto_english_#{@student.lastname+'_'+@student.name+'_'+@year.name}"
      guardar(doc,nombre_archivo_contrato)
    else
      respond_to do |format|
        format.html { redirect_to students_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # Para exportar el contrato del estudiante a Word (italiano)
  def download_initial_libretto
    # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario

    # Para saber si el archivo existe
    if File.exist?("#{Rails.root}/app/assets/templates/initial_libretto.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/initial_libretto.docx")
      @year = Acyear.find_by(id: @stay.acyear_id)
      @student = Student.find_by(id: @stay.student_id)
      actividades = Activity.where(acyear_id: @stay.acyear_id )
      @inscripciones = Enrollment.where(user_id: @student.user_id, activity_id: actividades.ids).to_a

      # Sustituir texto conservando el formato
      @inscripciones.each do |inscripcion|
        doc.tables.each do |table|
          first_row = table.rows.first
          # Copy last row and insert a new one before last row
          new_row = first_row.copy
          new_row.insert_after(table.rows.last)

          # Substitute text in each cell of this new row
          new_row.cells.each do |cell|
            cell.paragraphs.each do |paragraph|
              paragraph.each_text_run do |text|
                text.substitute('Tipologia', inscripcion.activity.name)
                text.substitute('Titolo', inscripcion.activity.description)
              end
            end
          end
        end
      end
      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @student.name)
          tr.substitute('Cognome', @student.lastname)
          tr.substitute('codicefiscale', @student.id_number)
          tr.substitute('classe', @stay.kind) if @stay.kind?
          tr.substitute('annoiscrizione', @stay.year_enrollment) if @stay.year_enrollment?
        end
      end

      nombre_archivo = "progetto_formativo_per_ministerio_#{@student.lastname+'_'+@student.name+'_'+@year.name}"
      guardar(doc,nombre_archivo)
    else
      respond_to do |format|
        format.html { redirect_to students_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end


  # Para exportar el contrato del estudiante a Word (italiano)
  def download_final_libretto
    # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario

    # Para saber si el archivo existe
    if File.exist?("#{Rails.root}/app/assets/templates/final_libretto.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/final_libretto.docx")
      @year = Acyear.find_by(id: @stay.acyear_id)
      actividades = Activity.where(acyear_id: @stay.acyear_id )
      @asistencias = Attendance.where(student_id: @stay.student_id, activity_id: actividades.ids).to_a
      @student = Student.find_by(id: @stay.student_id)

      # Sustituir texto conservando el formato
      @asistencias.each do |asistencia|
        doc.tables.each do |table|
          first_row = table.rows.first
          # Copy last row and insert a new one before last row
          new_row = first_row.copy
          new_row.insert_after(table.rows.last)

          # Substitute text in each cell of this new row
          new_row.cells.each do |cell|
            cell.paragraphs.each do |paragraph|
              paragraph.each_text_run do |text|
                text.substitute('Codice', asistencia.activity.kind.to_s)
                text.substitute('Argomento', asistencia.activity.name)
                text.substitute('ore', asistencia.activity.duration.to_s)
              end
            end
          end
        end
      end
      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @student.name)
          tr.substitute('Cognome', @student.lastname)
          tr.substitute('codicefiscale', @student.id_number)
          tr.substitute('classe', @stay.kind) if @stay.kind?
          tr.substitute('annoiscrizione', @stay.year_enrollment) if @stay.year_enrollment?
        end
      end

      nombre_archivo = "libretto_finale_per_ministerio_#{@student.lastname+'_'+@student.name+'_'+@year.name}"
      guardar(doc,nombre_archivo)
    else
      respond_to do |format|
        format.html { redirect_to students_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end


  # Para exportar el contrato del estudiante a Word (italiano)
  # OJO con el nombre el archivo, tiene que ser el mismo nombre con el que se guarda el archivo modelo que carga el usuario
  def downloadcontractitalian
    # Para saber si el archivo existe
    if File.exist?("#{Rails.root}/app/assets/templates/contract_italian.docx")
      doc = Docx::Document.open("#{Rails.root}/app/assets/templates/contract_italian.docx")
      @student = Student.find_by(id: @stay.student_id)
      @year = Acyear.find_by(id: @stay.acyear_id)
      # Sustituir texto conservando el formato
      doc.paragraphs.each do |p|
        p.each_text_run do |tr|
          tr.substitute('Nome', @student.name)
          tr.substitute('Cognome', @student.lastname)
          tr.substitute('*rettamensile*', @stay.fee.to_s) if @stay.fee?
          tr.substitute('*rettamensileparole*', @stay.fee.humanize) if @stay.fee?
          tr.substitute('*rettacomplessa*', @stay.annualfee.to_s) if @stay.annualfee?
          tr.substitute('*rettacomplessaparole*', @stay.annualfee.humanize) if @stay.annualfee?
          tr.substitute('datainizio', @stay.hosting_start_date.strftime("%d/%m/%Y").to_s) if @stay.hosting_start_date?
          tr.substitute('datafine', @stay.hosting_end_date.strftime("%d/%m/%Y").to_s) if @stay.hosting_end_date?
          tr.substitute('*mesi*', @stay.months.to_s) if @stay.months?
        end
      end

      # Remove paragraphs
      doc.paragraphs.each do |p|
        #p.remove! if p.to_s =~ /dottoranda(o) dell \' Universita degli Studi di Brescia/
        p.remove! if p.to_s == "visiting professor / guest"
      end
      if @stay.firsttime == true
        doc.paragraphs.each do |p|
          p.remove! if p.to_s =~ /Permanenza confermata, rinnovo retta per l’anno 2022-23/
        end
      end
      if @stay.firsttime == false
        doc.paragraphs.each do |p|
          p.remove! if p.to_s =~ /Nuovo ingresso anno 2022-23, a seguito della firma del “Contratto di ospitalità”/
        end
      end
      if @stay.grant == false
        doc.paragraphs.each do |p|
          p.remove! if p.to_s == "beneficiaria(o) della Borsa di studio INPS"
        end
      end
      if @stay.fee_reduction_request == false
        doc.paragraphs.each do |p|
          p.remove! if p.to_s =~ /esaminata e accolta la Sua domanda di riduzione della retta/
        end
      end
      if @stay.typology == 'S'
        doc.paragraphs.each do |p|
          #p.remove! if p.to_s =~ /dottoranda(o) dell \' Universita degli Studi di Brescia/
          p.remove! if p.to_s == "dottoranda/o dell'Università degli Studi di Brescia"
        end
      end

      nombre_archivo_contrato = "Contratto_italiano_#{@student.lastname+'_'+@student.name+'_'+@year.name}"
      guardar(doc,nombre_archivo_contrato)
      #ruta = "#{Rails.root}/app/assets/templates/"
      #doc.save("#{ruta}#{nombre_archivo_contrato}.docx")
    else
      respond_to do |format|
        format.html { redirect_to students_url, alert: "Non si puó scaricare il file, devi prima caricare il file modelo." }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # Guardar con otro nombre, descargar y borrar el documento
  def guardar(doc,nombre_archivo_contrato)
    ruta = "#{Rails.root}/app/assets/templates/"
    doc.save("#{ruta}#{nombre_archivo_contrato}.docx")

    # Esto funciona para cambiarlo a pdf pero se demora mucho la conversión
    # Libreconv.convert("#{ruta}#{nombre_archivo_contrato}.docx", "#{ruta}#{nombre_archivo_contrato}.pdf")
    # send_file "#{ruta}#{nombre_archivo_contrato}.pdf", :type=>"application/pdf", :x_sendfile=>true

    # Esto para exportar a word. Funciona, pero cuando le digo que borre el archivo ya no funciona (lo borra antes de enviarlo)
    # send_file "#{ruta}#{nombre_archivo_contrato}.docx", :type=>"application/docx", :x_sendfile=>true

    # Esto es para exportar a Word y que después se pueda borrar el archivo
    File.open(ruta+nombre_archivo_contrato+'.docx', 'r') do |f|
      send_data(f.read, filename: "#{nombre_archivo_contrato}.docx", type: "text/docx")
    end

    # Para borrarlo ya que lo exportó
    File.delete(ruta + "#{nombre_archivo_contrato}.docx")

    # El redirect no funciona porque send_data ya es un render y genera como double redirect en el mismo def, y eso no se puede
    #redirect_to activities_url
    #respond_to do |format|
    #  format.html { redirect_to activities_url, status: :ok, notice: "Contrato generado." }
    #  format.json { head :no_content }
    #end

  end

  # GET /stays or /stays.json
  def index
    @stays = Stay.all
  end

  # GET /stays/1 or /stays/1.json
  def show
    @student = Student.find_by_id(@stay.student_id)
  end

  # GET /stays/new
  def new
    @stay = Stay.new
  end

  # GET /stays/1/edit
  def edit
  end

  # POST /stays or /stays.json
  def create
    #params[:student_id] = "3"
    #@acyear = Acyear.find_by_id(params[:acyear_id])

    @stay = Stay.new(stay_params)
    @stay.student_id = params[:stay][:student_id]
    @stay.acyear_id = params[:acyear_id]
    #@stay = Stay.new(stay_params)
    respond_to do |format|
      if @stay.save
        format.html { redirect_to stay_url(@stay), notice: "Il soggiorno è stato creato con successo."}

        format.json { render :show, status: :created, location: @stay }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stays/1 or /stays/1.json

  def update
    @stay.acyear_id = params[:acyear_id]
    respond_to do |format|
      if @stay.update(stay_params)
        @graduation = Graduation.find_by(stay_id: @stay.id)
        @graduation.set_tipo if @graduation
        format.html { redirect_to stay_url(@stay), notice: " Il soggiorno è stato aggiornato con successo." }
        format.json { render :show, status: :ok, location: @stay }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stay.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /stays/1 or /stays/1.json
  def destroy
    @stay.destroy

    respond_to do |format|
      format.html { redirect_to stays_url, notice: "Il soggiorno è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_stay
      @stay = Stay.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stay_params
      params.require(:stay).permit(:student_id, :acyear_id, :year_enrollment, :hosting_start_date, :hosting_end_date, :fee, :annualfee,
        :fee_reduction_request, :grant,
        :firsttime, :periodgrades, :cumulativegrades,
        :hours_attended, :number_activities_attended,
        :attendance_status, :cumulativegrades_status, :periodgrades_status,
        :typology, :frame, :kind, :program_id, :gradesmin, :perc_attendance, :examfree
      )
    end
end
