import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "listSelect", "submit", "blockedHint", "title", "method", "heading"]

  connect() {
    this.editing = false
    this.prepareNew()
  }

  prepareNew(event) {
    this.editing = false

    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = "Nova tarefa"
    }

    if (this.hasTitleTarget) {
      this.titleTarget.value = ""
    }

    if (this.hasMethodTarget) {
      this.methodTarget.value = ""
      this.methodTarget.disabled = true
    }

    if (this.hasListSelectTarget) {
      const isEmpty = this.listSelectTarget.dataset.taskModalEmpty === "true"
      const preferredList = event?.currentTarget?.dataset?.taskListId

      this.listSelectTarget.disabled = isEmpty
      if (!isEmpty) {
        this.listSelectTarget.value = preferredList || this.listSelectTarget.options[0]?.value || ""
      }
    }

    if (this.hasSubmitTarget) {
      this.submitTarget.textContent = "Adicionar"
    }

    this.updateForm()
  }

  prepareEdit(event) {
    this.editing = true

    const { taskId, taskTitle, taskListId } = event.currentTarget.dataset
    const updateTemplate = this.formTarget.dataset.updateTemplate

    if (taskId && taskListId && updateTemplate) {
      this.formTarget.action = updateTemplate
        .replace(":list_id", taskListId)
        .replace(":id", taskId)
    }

    if (this.hasMethodTarget) {
      this.methodTarget.disabled = false
      this.methodTarget.value = "patch"
    }

    if (this.hasTitleTarget && taskTitle !== undefined) {
      this.titleTarget.value = taskTitle
    }

    if (this.hasListSelectTarget && taskListId) {
      this.listSelectTarget.value = taskListId
      this.listSelectTarget.disabled = true
    }

    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = "Editar tarefa"
    }

    if (this.hasSubmitTarget) {
      this.submitTarget.textContent = "Salvar"
      this.submitTarget.disabled = false
    }

    if (this.hasBlockedHintTarget) {
      this.blockedHintTarget.setAttribute("hidden", "hidden")
    }
  }

  updateForm() {
    if (!this.hasListSelectTarget || this.editing) {
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
