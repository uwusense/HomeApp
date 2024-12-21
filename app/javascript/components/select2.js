let isInitialized = false;

function initializeSelect2() {
  if(!isInitialized) {
    $('.sort-select').select2({
        minimumResultsForSearch: Infinity
    });

    $('.sort-select').off('change').on('change', function() {
      this.closest('form').submit();
    });
    isInitialized = true;

    $('.select2').select2({
      minimumResultsForSearch: Infinity
    })
  }
}

document.addEventListener("DOMContentLoaded", initializeSelect2);
document.addEventListener("turbo:load", initializeSelect2);
$(document).on("turbolinks:before-cache", function() {
  $('.select2').select2('destroy');
});

$(document).on('turbolinks:load', function() {
  initializeSelect2
});
