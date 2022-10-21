# Lo creeé yo según:
# https://www.youtube.com/watch?v=m3uhldUGVes
# Para poder que l devise funcione con turbo dado que el rails 7 tiene el turbo

class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end


  self.responder = Responder
  respond_to :html, :turbo_stream
end
