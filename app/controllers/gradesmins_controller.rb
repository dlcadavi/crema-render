class GradesminsController < ApplicationController
  before_action :authorize_admin

  def index
    @gradesmins=Gradesmin.all
  end

  def import
    Gradesmin.import(params[:file])
    redirect_to(root_path, :notice => "User Data imported :(")
  end

  private


  # Use callbacks to share common setup or constraints between actions.
  def set_gradesmin
    @gradesmin = Gradesmin.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gradesmin_params
    params.require(:gradesmin).permit(:area, :year, :grades)
  end

end
