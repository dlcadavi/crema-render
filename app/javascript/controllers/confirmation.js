// Configure Stimulus development experience
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  confirm(event) {
    if (!(window.confirm(this.element.dataset.message))) {
      event.preventDefault()
    }
  }
}
