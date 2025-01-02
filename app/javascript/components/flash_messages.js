function setupFlash() {
  setTimeout(() => {
    const flashes = document.querySelectorAll('.flash');
    console.log("flashes", flashes)
    flashes.forEach((flash) => {
      $(flash).fadeOut(500, function() {
        $(this).remove();
      });
    });
  }, 4000);
};

document.addEventListener('DOMContentLoaded', setupFlash);
document.addEventListener("turbo:load", setupFlash);
