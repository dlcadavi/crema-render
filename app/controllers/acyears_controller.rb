class AcyearsController < ApplicationController
  before_action :set_acyear, only: %i[ show edit update destroy ]

  before_action :authenticate_user!
  before_action :authorize_to_edit, only: [:create, :new, :edit, :update, :duplicate, :export_activities, :editattendance]
  before_action :authorize_admin, only: [:destroy]
  before_action :authorize_to_see, only: [:index, :show]


  # GET /acyears or /acyears.json
  def index
    @acyears = Acyear.all
  end

  # GET /acyears/1 or /acyears/1.json
  def show
  end

  # GET /acyears/new
  def new
    @acyear = Acyear.new
  end

  # GET /acyears/1/edit
  def edit
  end

  # POST /acyears or /acyears.json
  def create
    @acyear = Acyear.new(acyear_params)

    respond_to do |format|
      if @acyear.save
        format.html { redirect_to acyear_url(@acyear), notice: "Acyear was successfully created." }
        format.json { render :show, status: :created, location: @acyear }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @acyear.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acyears/1 or /acyears/1.json
  def update
    respond_to do |format|
      if @acyear.update(acyear_params)
        format.html { redirect_to acyear_url(@acyear), notice: "Acyear was successfully updated." }
        format.json { render :show, status: :ok, location: @acyear }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @acyear.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acyears/1 or /acyears/1.json
  def destroy
    @acyear.destroy

    respond_to do |format|
      format.html { redirect_to acyears_url, notice: "Acyear was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acyear
      @acyear = Acyear.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def acyear_params
      params.require(:acyear).permit(:name, :startdate, :finaldate,
        student_ids:[],
      )
    end
end
