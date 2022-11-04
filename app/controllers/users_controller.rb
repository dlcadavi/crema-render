
# Lo agregué yo
# https://www.youtube.com/watch?v=7Rs6CT9G5AM

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy]

  before_action :authenticate_user!
  before_action :authorize_admin, only: [:create, :new, :edit, :update, :destroy]
  before_action :authorize_to_see, only: [:index, :show]


  def index
    @users = User.all.order(:lastname, :name)
  end

  # GET /professors/1 or /professors/1.json
  def show
  end

  # GET /professors/1/edit
  def edit
  end


  # PATCH/PUT /professors/1 or /professors/1.json
  def update
    # Para que permita actualizar los usuarios sin insertar la password (quita los campos)
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: "L'utente è stato aggiornato con successo." }
        format.json { render :show, status: :see_other, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /professors/1 or /professors/1.json
  def destroy
    if @user.id == current_user.id
      redirect_to root_path, notice: "You can't delete your own account"
    else
      if @user.role.name == 'Admin'
        redirect_to root_path, notice: "You can't delete another Admin account"
      else
        @user.destroy
        respond_to do |format|
          format.html { redirect_to users_path, status: :see_other, notice: "L'utente è stato distrutto con successo." }
          format.json { head :no_content }
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :name, :lastname, :role_id, :password, :password_confirmation,
      activity_ids:[],
    )
  end


end
