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
  }
}

document.addEventListener("DOMContentLoaded", initializeSelect2);
document.addEventListener("turbo:load", initializeSelect2);
