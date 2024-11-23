class CatalogFilter
  constructor: ->
    @currentFilterCategory = null
    @currentFilterValue = null
    @currentSortDirection = 'newest'

    $(document).on 'click', '.catalog_filters_new_in__option', (e) =>
      $target = $(e.currentTarget)
      @processDateFilters($target)

    $(document).on 'click', '.catalog_filters_filter_option', (e) =>
      $target = $(e.currentTarget)
      @processDateFilters($target)

    $(document).on 'change', '.sort-select', (e) =>
      $target = $(e.currentTarget)
      @processSorting($target)
  
  processDateFilters: ($target) ->
      @currentFilterCategory = $target.data('filter')
      @currentFilterValue = $target.data('value')
      $target.siblings().removeClass('catalog_filters_new_in__option--active')
      $target.addClass('catalog_filters_new_in__option--active')
      @applyFilter()

  processMainFilters: ($target) ->
      @currentFilterCategory = $target.closest('.catalog_filters_filter').data('filter-category')
      @currentFilterValue = $target.text().trim()
      @applyFilter()

  processSorting: ($target) ->
    @currentSortDirection = $target.val()
    @applyFilter()

  showLoading: ->
    $catalogRow = $('.catalog_items_row')
    $catalogRow.empty()
    $catalogRow.append('<p class="loading-indicator">Loading...</p>')

  hideLoading: ->
    $('.loading-indicator').remove()

  applyFilter: ->
    url = $('[data-filter-url]').data('filter-url')
    category = $('[data-category]').data('category')

    @showLoading()

    $.ajax
      url: url
      method: 'GET'
      data: 
        sort_direction: @currentSortDirection
        filter_category: @currentFilterCategory
        filter_value: @currentFilterValue
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
