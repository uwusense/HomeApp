import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("connected")
    $('.select2').each(function () {
      if ($(this).data('select2')) {
        $(this).select2('destroy');
      }
    });

    $('.select2').select2({
      minimumResultsForSearch: Infinity
    });
  }

  disconnect() {
    console.log("disconnected");
    $('.select2').select2('destroy');
  }
}
