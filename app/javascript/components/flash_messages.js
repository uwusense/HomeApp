document.addEventListener('DOMContentLoaded', () => {
  setTimeout(() => {
    $('.flash').fadeOut(500, function() {
      $(this).remove();
    });
  }, 4000);
});
