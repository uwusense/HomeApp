function initializeSelect2() {
  $('.sort-select').select2({
      minimumResultsForSearch: Infinity
  });

  $('.sort-select').off('change').on('change', function() {
    this.closest('form').submit();
  });

  $('.select2').select2({
    minimumResultsForSearch: Infinity
  })
}

document.addEventListener("DOMContentLoaded", initializeSelect2);
document.addEventListener("turbo:load", initializeSelect2);
