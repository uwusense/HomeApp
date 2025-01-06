function initializeTooltip() {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
};

document.addEventListener("DOMContentLoaded", initializeTooltip);
document.addEventListener("turbo:load", initializeTooltip);
