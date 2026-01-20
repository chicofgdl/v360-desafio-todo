import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    const modalId = event.params.id || event.currentTarget.dataset.modalId
    if (!modalId) {
      return
    }

    const dialog = document.getElementById(modalId)
    if (!dialog) {
      return
    }

    if (typeof dialog.showModal === "function") {
      dialog.showModal()
    } else {
      dialog.setAttribute("open", "open")
    }
  }

  close(event) {
    const modalId = event.params.id || event.currentTarget.dataset.modalId
    if (!modalId) {
      return
    }

    const dialog = document.getElementById(modalId)
    if (!dialog) {
      return
    }

    if (typeof dialog.close === "function") {
      dialog.close()
    } else {
      dialog.removeAttribute("open")
    }
  }
}
