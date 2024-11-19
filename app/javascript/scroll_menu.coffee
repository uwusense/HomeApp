class ScrollMenu
  @BREAKPOINTS: [
    { width: 1280, itemsToShow: 6 },
    { width: 854, itemsToShow: 4 },
    { width: 640, itemsToShow: 3 },
    { width: 426, itemsToShow: 2 },
    { width: 0, itemsToShow: 1 }
  ]

  @RIGHTMARGIN = 10

  constructor: ($scrollMenu) ->
    @$scrollMenu = $scrollMenu
    @$scrollContent = @$scrollMenu.find('.scroll_menu_content')
    @scrollContentWidth = @$scrollContent.width()

    @itemsCount = @$scrollContent.children().length
    @$buttonsContainer = @$scrollMenu.find('.scroll_menu__button')
    @currentItemsToShow = @getItemsToShow()

    @resizeItems()

    @updateButtons()
    @$buttons = @$scrollMenu.find('[data-scroll], [data-arrow]')

    @scrollTo()

    $(window).resize => @initOnResize()

  initOnResize: ->
    @currentItemsToShow = @getItemsToShow()
    @scrollContentWidth = @$scrollContent.width()

    @resizeItems()

    @updateButtons()
    @$buttons = @$scrollMenu.find('[data-scroll]')

    @scrollTo()

  scrollTo: ->
    @$buttons.on 'click', (event) =>
      return if @isScrolling

      $button = $(event.currentTarget)
      if $button.data('arrow')
        @handleArrowScrollButton($button)
      else
        @handleRegularScrollButton($button)

  handleArrowScrollButton: ($button) =>
    @isScrolling = true
    direction = $button.data('arrow')
    scrollToPosition = @$scrollContent.scrollLeft()
    offset = @itemWidth * @currentItemsToShow + ScrollMenu.RIGHTMARGIN
    if direction == 'left'
      scrollToPosition -= offset
    else if direction == 'right'
      scrollToPosition += offset
    @$scrollContent.scrollLeft(scrollToPosition)
    setTimeout(() =>
      @isScrolling = false
    , 400)

  handleRegularScrollButton: ($button) =>
    @isScrolling = true
    @$buttons.removeClass('scroll_menu__button--active')
    $(event.currentTarget).addClass('scroll_menu__button--active')

    position = $(event.currentTarget).data('scroll') - 1
    totalMargin = position * @currentItemsToShow * ScrollMenu.RIGHTMARGIN
    scrollToPosition = @itemWidth * @currentItemsToShow * position + totalMargin
    @$scrollContent.scrollLeft(scrollToPosition)
    setTimeout(() =>
      @isScrolling = false
    , 400)

  getItemsToShow: ->
    itemsToShow = 1
    for breakpoint in ScrollMenu.BREAKPOINTS
      if @scrollContentWidth >= breakpoint.width
        return breakpoint.itemsToShow
    itemsToShow

  resizeItems: ->
    @itemWidth = (@scrollContentWidth / @currentItemsToShow) - (ScrollMenu.RIGHTMARGIN - 0.1)
    @$scrollContent.children().css 'width', "#{@itemWidth}px"

  updateButtons: ->
    numButtons = Math.ceil(@itemsCount / @currentItemsToShow)
    @$buttonsContainer.empty()

    if @currentItemsToShow <= 2
      leftArrow = $('<button>').attr('data-arrow', 'left').text('<')
      rightArrow = $('<button>').attr('data-arrow', 'right').text('>')
      leftArrow.addClass('scroll_menu__arrow--left')
      rightArrow.addClass('scroll_menu__arrow--right')
      @$buttonsContainer.append(leftArrow).append(rightArrow)
    else
      for i in [1..numButtons]
        button = $('<button>').attr('data-scroll', i).text("Page #{i}")
        button.addClass('scroll_menu__button--item') unless i is 1
        @$buttonsContainer.append(button)
      @$buttonsContainer.find('button:first').addClass('scroll_menu__buttton--active')


$('[data-scroll-menu]').each ->
  new ScrollMenu($(this))
