class ToggleMenu {
  // reusable dropdown functionality.
  constructor() {
    $(document).on('click', '[data-toggle-button]', (e) => this.toggleContent(e));
    $(document).on('click', (e) => this.handleClickOutside(e));
    $(window).on('resize', () => this.closeAllToggles());
  }

  toggleContent(e) {
    e.preventDefault();

    const $el = $(e.currentTarget);
    const $target = $($el.data('toggle-button'));
    const expanded = $el.data('toggle-expanded');
    const toggleClass = $el.data('toggle-class');
    const closeNestedToggles = $el.data('close-nested-toggles');

    $el.data('toggle-expanded', !expanded);
    if (toggleClass) {
      $el.toggleClass(toggleClass, !expanded);
    }

    $target.stop(true, true);
    if (expanded) {
      $target.slideUp('slow', () => {
        $target.trigger('toggleHideCompleted');
        if (closeNestedToggles) {
          this.toggleNestedToggles($target);
        }
      });
    } else {
      $target.slideDown('slow', () => {
        $target.trigger('toggleShowCompleted');
      });
    }
  }

  toggleNestedToggles($target) {
    $target.find('[data-toggle-target]').each((index, nestedToggler) => {
      const nestedTogglerExpanded = $(nestedToggler).data('toggle-expanded');
      if (nestedTogglerExpanded) {
        this.toggle($(nestedToggler));
      }
    });
  }

  handleClickOutside(e) {
    const $targetElements = $('[data-toggle-button], [data-toggle-target]');
    if ($targetElements.is(e.target) || $targetElements.has(e.target).length) {
      return;
    }

    this.closeAllToggles()
  }

  closeAllToggles() {
    $('[data-toggle-button]').each(function() {
      if ($(this).data('toggle-expanded')) {
        $(this).trigger('click');
      }
    });
  }
}

new ToggleMenu();
