import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "input"]

  connect() {
    this.toggleSubmitButton()
  }

  toggleSubmitButton() {
    const isInputEmpty = !this.inputTarget.value.trim()
    this.submitTarget.disabled = isInputEmpty
  }

  reset() {
    this.element.reset()
    this.toggleSubmitButton()
  }
}
