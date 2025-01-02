class CatalogFilter {
  constructor() {
    this.currentFilterDate = null;
    this.currentSortDirection = 'newest';
    this.currentMinPrice = null;
    this.currentMaxPrice = null;
    this.currentCondition = null;
    this.debouncedApplyFilter = _.debounce(this.applyFilter.bind(this), 500);

    $(document).on('click', '.catalog_filters_new_in__option', (e) => {
      const target = $(e.currentTarget);
      this.processDateFilters(target);
    });

    $(document).on('change', '.sort-select', (e) => {
      e.preventDefault();
      const target = $(e.currentTarget);
      this.processSorting(target);
    });

    $(document).on('input', '.price-range__input', (e) => {
      this.processPriceRange();
    });

    $(document).on('click', '.catalog_filters_condition_option', (e) => {
      const target = $(e.currentTarget);
      this.processCondition(target);
    });

    $(document).on('click', '.pagination a[data-remote="true"]', (e) => {
      e.preventDefault();
      const url = $(e.currentTarget).attr('href');
      this.applyFilter(url);
    });
  }

  processDateFilters(target) {
    this.currentFilterDate = target.data('filter-date');
    target.siblings().removeClass('catalog_filters_new_in__option--active');
    target.addClass('catalog_filters_new_in__option--active');
    this.showLoading();
    this.debouncedApplyFilter();
  }

  processSorting(target) {
    this.currentSortDirection = target.val();
    this.showLoading();
    this.debouncedApplyFilter();
  }

  processPriceRange() {
    this.currentMinPrice = $('[data-input="min"]').val();
    this.currentMaxPrice = $('[data-input="max"]').val();
    this.showLoading();
    this.debouncedApplyFilter();
  }

  processCondition(target) {
    this.currentCondition = target.data('filter-condition');
    target.siblings().removeClass('catalog_filters_condition_option--active');
    target.addClass('catalog_filters_condition_option--active');
    this.showLoading();
    this.debouncedApplyFilter();
  }

  showLoading() {
    $('.catalog_items_row').empty();
    $('.pagination').empty();
    const loadIndicator = $('.catalog_items__loading');
    loadIndicator.removeClass('hidden');
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', true);
  }

  hideLoading() {
    const loadIndicator = $('.catalog_items__loading');
    loadIndicator.addClass('hidden');
    $('.catalog_filters_new_in__option, .catalog_filters_filter_option, .sort-select').prop('disabled', false);
  }

  applyFilter(url = null) {
    url = url || $('#filter-form').attr('action') || window.location.href;
    const data = {
      sort_direction: this.currentSortDirection,
      date: this.currentFilterDate,
      min_price: this.currentMinPrice,
      max_price: this.currentMaxPrice,
      condition: this.currentCondition,
    };

    $.ajax({
      url: url,
      method: 'GET',
      data: data,
      dataType: 'json',
      success: (response) => {
        this.hideLoading();
        $('#items_list').html(response.items);
        $('#pagination').html(response.pagination);
      },
      error: (xhr, status, error) => {
        console.error("Error: " + error);
      }
    });
  }
}

new CatalogFilter();
