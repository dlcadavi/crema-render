class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]
  before_action :authorize_admin

  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update, :locationstudent]
  before_action :authorize_admin, only: [:destroy]
  before_action :authorize_to_see, only: [:index, :show, :locationsexport]


  # Para exportar las locations
  def locationsexport
    if params[:acyear_filter] != ""
      @stays = Stay.where(acyear_id: params[:acyear_filter])
      @locations = Location.where(stay_id: @stays.pluck(:id))
      @acyearid = params[:acyear_filter]
      annoname = Acyear.find_by(id: @acyearid).name
    else
      @locations = Location.all
      @acyearid = Acyear.all.pluck(:id)
      annoname = 'Tutti'
    end
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=Alloggi-Consulta#{Date.today}.csv"
      end
    end
  end

  def locationstudent
    @student = Student.find_by_id(params[:id])
    @stays = Stay.where(student_id: @student.id)
    @locations = Location.where(stay_id: @stays.pluck(:id))
  end


  # GET /locations or /locations.json
  def index
    @locations = Location.all.joins(stay: [:student, :acyear]).order('students.lastname', 'students.name', 'acyears.name DESC', 'locations.end_location_date DESC')
  end

  # GET /locations/1 or /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations or /locations.json
  def create
    @location = Location.new(location_params)
    @location.stay_id = params[:stay_id]


    respond_to do |format|
      if @location.save
        format.html { redirect_to location_url(@location), notice: "L'alloggio è stato creato con successo." }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "L'alloggio è stato aggiornat con successo." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "L'alloggio è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:stay_id, :start_location_date, :end_location_date, :fee, :room, :description, :months)
    end
end
