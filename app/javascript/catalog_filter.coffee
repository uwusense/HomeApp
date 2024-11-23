class CatalogFilter
  constructor: ->
    @currentFilterCategory = null
    @currentFilterValue = null
    @currentSortDirection = 'newest'
    @currentMinPrice = null
    @currentMaxPrice = null
    @debouncedApplyFilter = _.debounce(@applyFilter.bind(this), 500)

    $(document).on 'click', '.catalog_filters_new_in__option', (e) =>
      $target = $(e.currentTarget)
      @processDateFilters($target)

    $(document).on 'change', '.sort-select', (e) =>
      $target = $(e.currentTarget)
      @processSorting($target)

    $(document).on 'input', '.price-range__input', (e) =>
      console.log("PRICE RANGE CHANGED")
      @processPriceRange()
  
  processDateFilters: ($target) ->
      @currentFilterCategory = $target.data('filter')
      @currentFilterValue = $target.data('value')
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

  showLoading: ->
    $catalogRow = $('.catalog_items_row')
    $catalogRow.empty()
    $catalogRow.append('<p class="loading-indicator">Loading...</p>')
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', true)

  hideLoading: ->
    $('.loading-indicator').remove()
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', false)

  applyFilter: ->
    url = $('[data-filter-url]').data('filter-url')
    category = $('[data-category]').data('category')
    $.ajax
      url: url
      method: 'GET'
      data:
        sort_direction: @currentSortDirection
        filter_category: @currentFilterCategory
        filter_value: @currentFilterValue
        min_price: @currentMinPrice
        max_price: @currentMaxPrice
        tab: category
      success: (response) =>
        @hideLoading()
        @updateCatalogItems(response.items)
      error: (xhr, status, error) ->
        console.error "Error: #{error}"

  updateCatalogItems: (items) ->
    $catalogRow = $('.catalog_items_row')
    $catalogRow.empty()

    unless items?.length > 0
      $catalogRow.append('<p>No items found.</p>')
      return

    items.forEach (item) ->
      $catalogRow.append """
        <div class="catalog_item">
          <div class="catalog_item__photo">#{item.name}</div>
          <div class="catalog_item__title">#{item.name}</div>
          <div class="catalog_item__price">$ #{item.price}</div>
          <div class="catalog_item__seller">#{item.username}</div>
        </div>
      """

new CatalogFilter()
