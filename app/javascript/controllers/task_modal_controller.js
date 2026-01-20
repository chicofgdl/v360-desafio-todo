import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "listSelect", "submit", "blockedHint"]

  connect() {
    this.updateForm()
  }

  updateForm() {
    if (!this.hasListSelectTarget) {
      return
    }

    const listId = this.listSelectTarget.value
    const template = this.formTarget.dataset.actionTemplate

    if (!listId || !template) {
      this.disableSubmit()
      return
    }

    this.formTarget.action = template.replace(":list_id", listId)
    this.enableSubmit()
  }

  disableSubmit() {
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = true
    }
    if (this.hasBlockedHintTarget) {
      this.blockedHintTarget.removeAttribute("hidden")
    }
  }

  enableSubmit() {
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = false
    }
    if (this.hasBlockedHintTarget) {
      this.blockedHintTarget.setAttribute("hidden", "hidden")
    }
  }
}
