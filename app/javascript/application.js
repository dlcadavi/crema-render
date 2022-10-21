// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
//import { Turbo } from "@hotwired/turbo-rails" Turbo.session.drive = false
import "controllers"

// Para que importe mis propias funciones en jquerty
// Custom es una carpeta que yo creé en app/javascript/
import "custom/disable_html_controller"
import "custom/read_status_perc"
import "custom/add_new_activ_to_course"

import "chartkick"
import "Chart.bundle"
