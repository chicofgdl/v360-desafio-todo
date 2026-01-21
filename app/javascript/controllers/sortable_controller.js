import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = {
    url: String,
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: "[data-drag-handle], .drag-handle",
      onEnd: () => this.persist(),
    })
  }

  async persist() {
    const ids = Array.from(this.element.querySelectorAll("[data-task-id]")).map(
      (el) => el.dataset.taskId
    )

    const token = document.querySelector('meta[name="csrf-token"]').content

    await fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        Accept: "application/json",
      },
      body: JSON.stringify({ ordered_ids: ids }),
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }
}
