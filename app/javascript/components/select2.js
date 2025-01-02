function initializeSelect2() {
  $('.sort-select').select2({
      minimumResultsForSearch: Infinity
  });

  $('.select2').select2({
    minimumResultsForSearch: Infinity
  })
}

document.addEventListener("DOMContentLoaded", initializeSelect2);
document.addEventListener("turbo:load", initializeSelect2);
