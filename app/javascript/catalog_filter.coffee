class CatalogFilter
  constructor: ->
    @currentFilterDate = null
    @currentSortDirection = 'newest'
    @currentMinPrice = null
    @currentMaxPrice = null
    @currentCondition = null
    @debouncedApplyFilter = _.debounce(@applyFilter.bind(this), 500)

    $(document).on 'click', '.catalog_filters_new_in__option', (e) =>
      $target = $(e.currentTarget)
      @processDateFilters($target)

    $(document).on 'change', '.sort-select', (e) =>
      $target = $(e.currentTarget)
      @processSorting($target)

    $(document).on 'input', '.price-range__input', (e) =>
      @processPriceRange()

    $(document).on 'click', '.catalog_filters_condition_option', (e) =>
      $target = $(e.currentTarget)
      @processCondition($target)

    $(document).on 'click', '.pagination a[data-remote=true]', (e) =>
      e.preventDefault()
      url = $(e.currentTarget).attr('href')
      @applyFilter url
  
  processDateFilters: ($target) ->
      @currentFilterDate = $target.data('filter-date')
      $target.siblings().removeClass('catalog_filters_new_in__option--active')
      $target.addClass('catalog_filters_new_in__option--active')
      @showLoading()
      @debouncedApplyFilter()

  processMainFilters: ($target) ->
      @currentFilterCategory = $target.closest('.catalog_filters_filter').data('filter-category')
      @currentFilterValue = $target.text().trim()
      @showLoading()
      @debouncedApplyFilter()

  processSorting: ($target) ->
    @currentSortDirection = $target.val()
    @showLoading()
    @debouncedApplyFilter()

  processPriceRange: ($target) ->
    @currentMinPrice = $('[data-input="min"]').val()
    @currentMaxPrice = $('[data-input="max"]').val()
    @showLoading()
    @debouncedApplyFilter()

  processCondition: ($target) ->
    @currentCondition = $target.data('filter-condition')
    $target.siblings().removeClass('catalog_filters_condition_option--active')
    $target.addClass('catalog_filters_condition_option--active')
    @showLoading()
    @debouncedApplyFilter()

  showLoading: ->
    $('.catalog_items_row').empty()
    $('.pagination').empty()
    $loadIndicator = $('.catalog_items__loading')
    $loadIndicator.removeClass('hidden')
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', true)

  hideLoading: ->
    $loadIndicator = $('.catalog_items__loading')
    $loadIndicator.addClass('hidden')
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', false)

  applyFilter: (url = null) ->
    url ?= $('#filter-form').attr('action') || window.location.href
    data = {
      sort_direction: @currentSortDirection
      date: @currentFilterDate
      min_price: @currentMinPrice
      max_price: @currentMaxPrice
      condition: @currentCondition
    }

    $.ajax
      url: url
      method: 'GET'
      data: data
      dataType: 'json'
      success: (response) =>
        @hideLoading()
        $('#items_list').html(response.items)
        $('#pagination').html(response.pagination)
      error: (xhr, status, error) ->
        console.error "Error: #{error}"

new CatalogFilter()
