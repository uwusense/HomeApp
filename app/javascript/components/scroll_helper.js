document.addEventListener('turbo:load', () => {
  const container = document.querySelector('[data-scroll-container]');
  if (container) container.scrollTop = container.scrollHeight;
});

document.addEventListener('turbo:before-stream-render', (event) => {
  const container = document.querySelector('[data-scroll-container]');
  if (event.target.action === 'append' && container) {
    setTimeout(() => {
      container.scrollTop = container.scrollHeight;
    }, 0);
  }
});
