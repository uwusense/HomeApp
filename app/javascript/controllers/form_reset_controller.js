import { Controller } from "@hotwired/stimulus"
// Chat room form reset functionality upon creation of message. (When sending message we reset form)
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
