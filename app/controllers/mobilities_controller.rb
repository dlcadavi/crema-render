class MobilitiesController < ApplicationController
  before_action :set_mobility, only: %i[ show edit update destroy ]
  before_action :authorize_admin


  # Para exportar las mobilidades
  def mobilitiesexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @mobilities = Mobility.where(stay_id: @stays.pluck(:id))
      @acyearid = params[:acyear_filter]
      annoname = Acyear.find_by(id: @acyearid).name
    else
      @mobilities = Mobility.all
      @acyearid = Acyear.all.pluck(:id)
      annoname = 'Tutti'
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Mobilita-Consulta#{Date.today}.csv"
      end
    end
  end


  def mobilitystudent
    @student = Student.find_by_id(params[:id])
    @stays = Stay.where(student_id: @student.id)
    @mobilities = Mobility.where(stay_id: @stays.pluck(:id))
  end

  # GET /mobilities or /mobilities.json
  def index
    @mobilities = Mobility.all
  end

  # GET /mobilities/1 or /mobilities/1.json
  def show
  end

  # GET /mobilities/new
  def new
    @mobility = Mobility.new
  end

  # GET /mobilities/1/edit
  def edit
  end

  # POST /mobilities or /mobilities.json
  def create
    @mobility = Mobility.new(mobility_params)
    @mobility.stay_id = params[:stay_id]

    respond_to do |format|
      if @mobility.save
        format.html { redirect_to mobility_url(@mobility), notice: "La mobilità e stata creata con successo." }
        format.json { render :show, status: :created, location: @mobility }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mobility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mobilities/1 or /mobilities/1.json
  def update
    respond_to do |format|
      if @mobility.update(mobility_params)
        format.html { redirect_to mobility_url(@mobility), notice: "La mobilità e stata aggiornata con successo." }
        format.json { render :show, status: :ok, location: @mobility }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mobility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mobilities/1 or /mobilities/1.json
  def destroy
    @mobility.destroy

    respond_to do |format|
      format.html { redirect_to mobilities_url, notice: "La mobilità è stata distrutta con successo." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobility
      @mobility = Mobility.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mobility_params
      params.require(:mobility).permit(:stay_id, :start_mobility_date, :end_mobility_date, :country, :description, :mobility_program)
    end
end
