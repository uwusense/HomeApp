class ToggleMenu
  constructor: ->
    $(document).on 'click', '[data-toggle-button]', @toggleContent
    $(document).on 'click', (e) => @handleClickOutside(e)

  toggleContent: (e) =>
    e.preventDefault()

    $el = $(e.currentTarget)
    $target = $($el.data('toggleButton'))
    expanded = $el.data('toggleExpanded')
    toggleClass = $el.data('toggleClass')
    closeNestedToggles = $el.data('closeNestedToggles')

    $el.data('toggle-expanded', !expanded)
    $el.toggleClass(toggleClass, !expanded) if toggleClass

    $target.stop(true, true)
    if expanded
      $target.slideUp 'slow', =>
        $target.trigger('toggleHideCompleted')
        @toggleNestedToggles($target) if closeNestedToggles
    else
      $target.slideDown 'slow', ->
        $target.trigger('toggleShowCompleted')
  
  toggleNestedToggles: ($target) ->
    $target.find('[data-toggle-target]').each (index, nestedToggler) =>
      nestedTogglerExpanded = $(nestedToggler).data('toggleExpanded')

      if nestedTogglerExpanded
        @toggle($(nestedToggler))

  handleClickOutside: (e) =>
    return if $(e.target).closest('[data-toggle-button], [data-toggle-target]').length

    $('[data-toggle-button]').each ->
      if $(this).data('toggleExpanded')
        $(this).trigger('click')

new ToggleMenu()
