import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    $('.select2').select2({
      minimumResultsForSearch: Infinity
    });

    document.addEventListener("turbo:before-cache", this.destroySelect2);
  }

  disconnect() {
    this.destroySelect2();
    document.removeEventListener("turbo:before-cache", this.destroySelect2);
  }

  destroySelect2 = () => {
    $('.select2').each(function () {
      if ($(this).data('select2')) {
        $(this).select2('destroy');
      }
    });
  };
}
