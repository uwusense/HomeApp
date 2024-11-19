$ ->
  $('.catalog_filters_new_in__options p').on 'click', (e) ->
    $target = $(e.currentTarget)
    filterCategory = $target.data('filter')
    filterValue = $target.data('value')

    $target.siblings().removeClass('active')
    $target.addClass('active')

    applyFilter(filterCategory, filterValue)
  
  $('.catalog_filters_filter_option').on 'click', (e) ->
    $target = $(e.currentTarget)
    filterCategory = $target.closest('.catalog_filters_filter').data('filter-category')
    filterValue = $target.text().trim()
    applyFilter(filterCategory, filterValue)

  applyFilter = (filterCategory, filterValue) ->
    console.log("applying filter: #{filterCategory}, #{filterValue}")
    $.ajax
      url: '/catalog'
      method: 'GET'
      data: { filter_category: filterCategory, filter_value: filterValue, tab: $('.catalog_items_wrapper').data('tab') }
      success: (response) ->
        updateCatalogItems(response.items)

  updateCatalogItems = (items) ->
    $catalogRow = $('.catalog_items_row')
    $catalogRow.empty()

    items.forEach (item) ->
      $catalogRow.append("""
        <div class="catalog_item">
          <div class="catalog_item__photo">#{item.name}</div>
          <div class="catalog_item__title">Test title</div>
          <div class="catalog_item__price">$ #{item.price}</div>
          <div class="catalog_item__seller">Test seller</div>
        </div>
      """)
