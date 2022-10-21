class GuestsController < ApplicationController
  before_action :set_guest, only: %i[ show edit update destroy ]
  before_action :authorize_admin

  # Autorizaciones
  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update]
  before_action :authorize_admin, only: [:destroy]
  before_action :authorize_to_see, only: [:index, :show, :export_guests]

  # Exportar a excel información profesores
  def export_guests
    if params[:acyear_filter] != ""
      @visits = Visit.where(acyear_id: params[:acyear_filter])
      @guests = Guest.where(id: @visits.pluck(:id)).order(:lastname, :name)
    else
      @guests = Guest.order(:lastname, :name)
    end
    atributos =%w{ name lastname email phone_number id_number university hosting_start_date hosting_end_date }
    nombres_columnas = ["Name","Cognome","Email","Telefono","CF","Istituzione","Data inizio", "Data fine"]
    send_data @guests.to_csv(@guests,atributos,nombres_columnas), filename: "Anagrafica_guest-#{Date.today}.csv"
  end

  # GET /guests or /guests.json
  def index
    @guests = Guest.all.order(:lastname, :name)
  end

  # GET /guests/1 or /guests/1.json
  def show
  end

  # GET /guests/new
  def new
    @guest = Guest.new
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests or /guests.json
  def create
    @guest = Guest.new(guest_params)

    respond_to do |format|
      if @guest.save
        format.html { redirect_to guest_url(@guest), notice: "Il guest è stato creato con successo." }
        format.json { render :show, status: :created, location: @guest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guests/1 or /guests/1.json
  def update
    respond_to do |format|
      if @guest.update(guest_params)
        format.html { redirect_to guest_url(@guest), notice: "Il professore è stato aggiornato con successo." }
        format.json { render :show, status: :ok, location: @guest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1 or /guests/1.json
  def destroy
    @guest.destroy

    respond_to do |format|
      format.html { redirect_to guests_url, notice: "Il guest è stato distrutto con successo." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def guest_params
      params.require(:guest).permit(:name, :lastname, :id_number, :birthdate, :hosting_start_date, :hosting_end_date, :email,
        :phone_number, :fee, :annualfee, :months, :gender, :university, :country_of_birth)
    end
end
