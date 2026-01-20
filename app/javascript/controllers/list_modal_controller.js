import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "title", "method", "submit", "heading"]

  connect() {
    this.prepareNew()
  }

  prepareNew() {
    if (!this.hasFormTarget) {
      return
    }

    const createAction = this.formTarget.dataset.createAction
    if (createAction) {
      this.formTarget.action = createAction
    }

    if (this.hasMethodTarget) {
      this.methodTarget.value = ""
      this.methodTarget.disabled = true
    }

    if (this.hasTitleTarget) {
      this.titleTarget.value = ""
    }

    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = "Nova lista"
    }

    if (this.hasSubmitTarget) {
      this.submitTarget.textContent = "Criar lista"
    }
  }

  prepareEdit(event) {
    if (!this.hasFormTarget) {
      return
    }

    const { listId, listTitle } = event.currentTarget.dataset
    const updateTemplate = this.formTarget.dataset.updateTemplate

    if (listId && updateTemplate) {
      this.formTarget.action = updateTemplate.replace(":id", listId)
    }

    if (this.hasMethodTarget) {
      this.methodTarget.disabled = false
      this.methodTarget.value = "patch"
    }

    if (this.hasTitleTarget && listTitle !== undefined) {
      this.titleTarget.value = listTitle
    }

    if (this.hasHeadingTarget) {
      this.headingTarget.textContent = "Editar lista"
    }

    if (this.hasSubmitTarget) {
      this.submitTarget.textContent = "Salvar"
    }
  }
}
