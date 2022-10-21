require_relative "boot"

# Require csv: para que lea desde csv y exporte a csv. Lo puse yo manualmente.
require 'csv'

# Require docs: para que lea desde docs y exporte a docx. Lo puse yo manualmente.
require 'docx'

# Para convertir a PDF
require 'libreconv'


# Para pasar nùmeros a palabras
require 'humanize'

# Para capturar la fecha de hoy
require 'date'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crema
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Europe/Rome"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
