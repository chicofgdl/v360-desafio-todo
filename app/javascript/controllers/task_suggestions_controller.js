import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "label", "icon", "spinner"]

  connect() {
    this.idleLabel = this.labelTarget.textContent
  }

  start() {
    this.buttonTarget.disabled = true
    this.buttonTarget.setAttribute("aria-busy", "true")
    this.labelTarget.textContent = "Gerando..."
    this.iconTarget.classList.add("hidden")
    this.spinnerTarget.classList.remove("hidden")
  }

  end() {
    this.buttonTarget.disabled = false
    this.buttonTarget.removeAttribute("aria-busy")
    this.labelTarget.textContent = this.idleLabel
    this.iconTarget.classList.remove("hidden")
    this.spinnerTarget.classList.add("hidden")
  }
}
