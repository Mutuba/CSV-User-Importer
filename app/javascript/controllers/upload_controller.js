import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput", "errorMessage"];

  async handleSubmit(event) {
    event.preventDefault();

    const form = event.target;
    const formData = new FormData(form);

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          Accept: "application/json",
        },
      });

      const data = await response.json();
      if (response.ok) {
        this.clearModal();
      } else {
        this.displayError(data.error || "Upload failed. Please try again.");
      }
    } catch (error) {
      this.displayError(error.message);
    }
  }

  displayError(message) {
    if (this.hasErrorMessageTarget) {
      this.errorMessageTarget.textContent = message;
      this.errorMessageTarget.classList.remove("d-none");
    }
  }

  clearModal() {
    const modalElement = document.getElementById("uploadModal");
    const modal =
      bootstrap.Modal.getInstance(modalElement) ||
      new bootstrap.Modal(modalElement);

    modal.hide();

    this.fileInputTarget.value = "";
    this.errorMessageTarget.classList.add("d-none");
  }
}
