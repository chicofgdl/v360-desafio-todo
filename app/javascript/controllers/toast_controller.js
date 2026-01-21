import { Controller } from "@hotwired/stimulus"
import { Notyf } from "notyf"

export default class extends Controller {
  connect() {
    const message = this.element.dataset.toastMessage
    if (!message) {
      this.element.remove()
      return
    }

    const type = this.element.dataset.toastType || "info"

    try {
      if (!window.__notyf__) {
        window.__notyf__ = new Notyf({
          duration: 3000,
          dismissible: true,
          position: { x: "right", y: "top" },
          types: [
            { type: "info", className: "app-notyf app-notyf--info", icon: false },
            { type: "success", className: "app-notyf app-notyf--success", icon: false },
            { type: "error", className: "app-notyf app-notyf--error", icon: false },
          ],
        })
      }

      this.placeNotyfContainer()

      const notyf = window.__notyf__
      if (type === "error") {
        notyf.error(message)
      } else if (type === "success") {
        notyf.success(message)
      } else {
        notyf.open({ type: "info", message })
      }

    } catch (error) {
      console.warn("Toast failed to render.", error)
    } finally {
      this.element.remove()
    }
  }

  placeNotyfContainer() {
    const container = document.querySelector(".notyf")
    if (!container) {
      return
    }

    const openDialogs = Array.from(document.querySelectorAll("dialog[open]"))
    const activeDialog = openDialogs[openDialogs.length - 1]

    if (activeDialog && !activeDialog.contains(container)) {
      activeDialog.appendChild(container)
      return
    }

    if (!activeDialog && container.parentElement !== document.body) {
      document.body.appendChild(container)
    }
  }
}
