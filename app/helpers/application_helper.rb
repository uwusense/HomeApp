module ApplicationHelper
  def navigation_items
    safe_join(
      Product::CATEGORIES.map do |tab|
        link_to I18n.t(tab, scope: 'categories'), catalog_path(tab: tab), class: 'navigation__item'
      end
    )
  end

  def navigation_dropdown_items
    safe_join(
      Product::CATEGORIES.map do |tab|
        link_to I18n.t(tab, scope: 'categories'), catalog_path(tab: tab), class: 'navigation_dropdown__item'
      end
    )
  end

  def sort_options(value)
    content_tag :div, class: 'sort-box-wrapper' do
      concat content_tag(:span, 'Sort by:', class: 'sort-box-title')
      concat(form_with(url: catalog_path(tab: params[:tab]), method: :get, local: true, id: 'sort-form') do
        select_tag(
          :sort,
          options_for_select(
            [
              ['Newest', 'newest'],
              ['Oldest', 'oldest'],
              ['Price ascending', 'price_asc'],
              ['Price descending', 'price_desc']
            ],
            selected: value
          ),
          include_blank: false, class: 'sort-select', onchange: 'this.form.submit();'
        )
      end)
    end
  end
end
