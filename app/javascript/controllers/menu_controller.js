import { Controller } from "@hotwired/stimulus"

// Closes a <details> menu when the user taps outside it or presses Escape.
export default class extends Controller {
  connect() {
    this.closeOnOutsideClick = (event) => {
      if (!this.element.contains(event.target)) this.element.open = false
    }
    this.closeOnEscape = (event) => {
      if (event.key === "Escape") this.element.open = false
    }
    document.addEventListener("click", this.closeOnOutsideClick)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnOutsideClick)
    document.removeEventListener("keydown", this.closeOnEscape)
  }
}
