import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.messages = document.getElementById("messages");
    this.observer = new MutationObserver(() => this.resetScroll());
    this.observeMessages();
    this.resetScroll(messages);
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  observeMessages() {
    if (this.messages) {
      this.observer.observe(this.messages, { childList: true });
    }
  }

  resetScroll() {
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}
