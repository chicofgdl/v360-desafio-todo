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

    this.moveNotyfContainer(dialog)
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

    this.restoreNotyfContainer()
  }

  moveNotyfContainer(dialog) {
    const container = document.querySelector(".notyf")
    if (!container) {
      return
    }

    if (dialog && !dialog.contains(container)) {
      dialog.appendChild(container)
    }
  }

  restoreNotyfContainer() {
    const container = document.querySelector(".notyf")
    if (!container) {
      return
    }

    const openDialogs = Array.from(document.querySelectorAll("dialog[open]"))
    const activeDialog = openDialogs[openDialogs.length - 1]

    if (activeDialog) {
      activeDialog.appendChild(container)
      return
    }

    if (container.parentElement !== document.body) {
      document.body.appendChild(container)
    }
  }
}
