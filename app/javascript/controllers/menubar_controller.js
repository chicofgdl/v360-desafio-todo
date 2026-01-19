import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.restoreTheme()
  }

  openExclusive(event) {
    const currentMenu = event.currentTarget.closest("details")
    if (!currentMenu) {
      return
    }

    this.menuTargets.forEach((menu) => {
      if (menu !== currentMenu) {
        menu.removeAttribute("open")
      }
    })
  }

  applyTheme(event) {
    const theme = event.currentTarget.dataset.themeValue
    if (!theme) {
      return
    }

    document.body.dataset.theme = theme

    try {
      window.localStorage.setItem("theme", theme)
    } catch {
      
    }

    this.closeAll()
  }

  closeAll() {
    this.menuTargets.forEach((menu) => menu.removeAttribute("open"))
  }

  restoreTheme() {
    let savedTheme

    try {
      savedTheme = window.localStorage.getItem("theme")
    } catch {
      savedTheme = null
    }

    if (savedTheme) {
      document.body.dataset.theme = savedTheme
    }
  }
}
