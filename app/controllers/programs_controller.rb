class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy]
  before_action :authorize_admin

  def index
    @programs=Program.all.order(:name)
  end

  def import
    Program.import(params[:file])
    redirect_to programs_url, notice: "Si sono caricati i programmi"
  end

  def massive_destroy
    @programs=Program.all.order(:name)
    @programs.each do |program|
      begin
        program.destroy
      rescue ActiveRecord::InvalidForeignKey
      end
    end
    redirect_to programs_url, notice: "Hai cancellato tutti i programmi che non sono stati usati finora"
  end

  # GET /students/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to program_url(@program), notice: "Il programma è stato aggiornato con successo." }
        format.json { render :show, status: :see_other, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # atrapar el error cuando se va a eliminar un programa, para que no genere páginas sin cargar
  def destroy
    begin
      @program.destroy
    rescue ActiveRecord::InvalidForeignKey
      @stays = Stay.where(program_id: @program.id)
      @students = Student.where(id: @stays.pluck(:student_id))
      respond_to do |format|
        #format.json { render json: {error: 'did not work because reasons'}.to_json, status: :forbidden }
        format.html { redirect_to programs_url, alert: "Non si può cancellare questo programma perche #{@students.count} studenti l'utilizzano nel suo soggiorno"}
      end
      #puts "Programa #{@program.id} not destroyed"
      #respond_to :html, programs_url, notice: "No se puede"
    else
      respond_to do |format|
        format.html { redirect_to programs_url, status: :see_other, notice: "Il programma è stato distrutto con successo." }
        format.json { head :no_content }
      end
    end
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:code, :name, :area)
    end

end
