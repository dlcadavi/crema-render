class ReportsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_to_see, only: [:index]

  # GET /reports or /reports.json
  def index
  end


end
