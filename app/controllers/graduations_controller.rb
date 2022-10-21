class GraduationsController < ApplicationController
  before_action :set_graduation, only: %i[ show edit update destroy ]
  before_action :authorize_admin


  # Para exportar las graduaciones
  def graduationsexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @graduations = Graduation.where(stay_id: @stays.pluck(:id))
      @acyearid = params[:acyear_filter]
      annoname = Acyear.find_by(id: @acyearid).name
    else
      @graduations = Graduation.all
      @acyearid = Acyear.all.pluck(:id)
      annoname = 'Tutti'
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=VotiDiLaurea-Consulta#{Date.today}.csv"
      end
    end
  end

  def graduationstudent
    @student = Student.find_by_id(params[:id])
    @stays = Stay.where(student_id: @student.id)
    @graduations = Graduation.where(stay_id: @stays.pluck(:id))
  end

  # GET /graduations or /graduations.json
  def index
    @graduations = Graduation.all
  end

  # GET /graduations/1 or /graduations/1.json
  def show
  end

  # GET /graduations/new
  def new
    @graduation = Graduation.new
  end

  # GET /graduations/1/edit
  def edit
  end

  # POST /graduations or /graduations.json
  def create
    @graduation = Graduation.new(graduation_params)
    @graduation.stay_id = params[:stay_id]

    respond_to do |format|
      if @graduation.save
        format.html { redirect_to graduation_url(@graduation), notice: "Il voto finale di laurea è stato creato con successo." }
        format.json { render :show, status: :created, location: @graduation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @graduation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graduations/1 or /graduations/1.json
  def update
    respond_to do |format|
      if @graduation.update(graduation_params)
        format.html { redirect_to graduation_url(@graduation), notice: "Il voto finale di laurea è stato aggiornato con successo." }
        format.json { render :show, status: :ok, location: @graduation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @graduation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /graduations/1 or /graduations/1.json
  def destroy
    @graduation.destroy

    respond_to do |format|
      format.html { redirect_to graduations_url, notice: "Il voto finale di laurea è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_graduation
      @graduation = Graduation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def graduation_params
      params.require(:graduation).permit(:stay_id, :graduation_date, :grades, :tipo, :lode, :encomio,
      )
    end

    # Only allow a list of trusted parameters through.
    #def graduation_params
    #  params.fetch(:graduation, {})
    #end
end
