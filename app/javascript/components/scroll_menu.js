class ScrollMenu {
  static BREAKPOINTS = [
    { width: 1280, itemsToShow: 6 },
    { width: 854, itemsToShow: 4 },
    { width: 640, itemsToShow: 3 },
    { width: 426, itemsToShow: 2 },
    { width: 0, itemsToShow: 1 }
  ];

  static RIGHTMARGIN = 10;

  constructor($scrollMenu) {
    this.$scrollMenu = $scrollMenu;
    this.$scrollContent = this.$scrollMenu.find('.scroll_menu_content');
    this.scrollContentWidth = this.$scrollContent.width();

    this.itemsCount = this.$scrollContent.children().length;
    this.$buttonsContainer = this.$scrollMenu.find('.scroll_menu__button');
    this.currentItemsToShow = this.getItemsToShow();

    this.resizeItems();
    this.updateButtons();
    this.$buttons = this.$scrollMenu.find('[data-scroll], [data-arrow]');

    this.scrollTo();

    $(window).on('resize', () => this.initOnResize());
  }

  initOnResize() {
    this.currentItemsToShow = this.getItemsToShow();
    this.scrollContentWidth = this.$scrollContent.width();

    this.resizeItems();
    this.updateButtons();
    this.$buttons = this.$scrollMenu.find('[data-scroll], [data-arrow]');

    this.scrollTo();
  }

  scrollTo() {
    this.$buttons.on('click', (event) => {
      if (this.isScrolling) return;

      const $button = $(event.currentTarget);
      if ($button.data('arrow')) {
        this.handleArrowScrollButton($button);
      } else {
        this.handleRegularScrollButton($button);
      }
    });
  }

  handleArrowScrollButton($button) {
    this.isScrolling = true;
    const direction = $button.data('arrow');
    let scrollToPosition = this.$scrollContent.scrollLeft();
    const totalMargin = this.currentItemsToShow * ScrollMenu.RIGHTMARGIN;
    const offset = this.itemWidth * this.currentItemsToShow + totalMargin;

    if (direction === 'left') {
      scrollToPosition -= offset;
    } else if (direction === 'right') {
      scrollToPosition += offset;
    }

    this.$scrollContent.scrollLeft(scrollToPosition);
    setTimeout(() => {
      this.isScrolling = false;
    }, 400);
  }

  handleRegularScrollButton($button) {
    this.isScrolling = true;
    this.$buttons.removeClass('scroll_menu__button--active');
    $button.addClass('scroll_menu__button--active');

    const position = $button.data('scroll') - 1;
    const totalMargin = position * this.currentItemsToShow * ScrollMenu.RIGHTMARGIN;
    const scrollToPosition = this.itemWidth * this.currentItemsToShow * position + totalMargin;

    this.$scrollContent.scrollLeft(scrollToPosition);
    setTimeout(() => {
      this.isScrolling = false;
    }, 400);
  }

  getItemsToShow() {
    let itemsToShow = 1;
    for (let breakpoint of ScrollMenu.BREAKPOINTS) {
      if (this.scrollContentWidth >= breakpoint.width) {
        return breakpoint.itemsToShow;
      }
    }
    return itemsToShow;
  }

  resizeItems() {
    this.itemWidth = (this.scrollContentWidth / this.currentItemsToShow) - (ScrollMenu.RIGHTMARGIN - 0.1);
    this.$scrollContent.children().css('width', `${this.itemWidth}px`);
  }

  updateButtons() {
    const numButtons = Math.ceil(this.itemsCount / this.currentItemsToShow);
    this.$buttonsContainer.empty();

    if (this.currentItemsToShow <= 2) {
      const leftArrow = $('<button>').attr('data-arrow', 'left').text('<');
      const rightArrow = $('<button>').attr('data-arrow', 'right').text('>');
      leftArrow.addClass('scroll_menu__arrow--left');
      rightArrow.addClass('scroll_menu__arrow--right');
      this.$buttonsContainer.append(leftArrow).append(rightArrow);
    } else {
      for (let i = 1; i <= numButtons; i++) {
        const button = $('<button>').attr('data-scroll', i).text(`Page ${i}`);
        button.addClass('scroll_menu__button--item').toggleClass('scroll_menu__button--active', i === 1);
        this.$buttonsContainer.append(button);
      }
    }
  }
}

$('[data-scroll-menu]').each(function() {
  new ScrollMenu($(this));
});
