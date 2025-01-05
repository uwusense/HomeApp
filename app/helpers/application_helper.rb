module ApplicationHelper
  def navigation_items
    safe_join(
      [
        link_to(I18n.t(:new_in, scope: 'categories'), catalogs_path(tab: 'new_in'), class: 'navigation__item'),
        Product::CATEGORIES.map do |tab|
          link_to(I18n.t(tab, scope: 'categories'), catalogs_path(tab: tab), class: 'navigation__item')
        end
      ]
    )
  end

  def navigation_dropdown_items
    safe_join(
      [
        link_to(I18n.t(:new_in, scope: 'categories'), catalogs_path(tab: 'new_in'), class: 'navigation_dropdown__item'),
        Product::CATEGORIES.map do |tab|
          link_to I18n.t(tab, scope: 'categories'), catalogs_path(tab: tab), class: 'navigation_dropdown__item'
        end
      ]
    )
  end

  def sort_options(value, category)
    content_tag :div, class: 'sort-box-wrapper', data: { category: category, sort: value } do
      concat content_tag(:span, t(:sort, scope: 'catalog'), class: 'sort-box-title')
      concat select_tag(
        :sort,
        options_for_select(
          [
            [t(:sort_newest, scope: 'catalog'), 'newest'],
            [t(:sort_oldest, scope: 'catalog'), 'oldest'],
            [t(:sort_price_asc, scope: 'catalog'), 'price_asc'],
            [t(:sort_price_desc, scope: 'catalog'), 'price_desc']
          ],
          selected: value
        ),
        include_blank: false,
        class: 'select2 sort-select',
        data: { action: 'change->catalog-filter#sort' }
      )
    end
  end
end
