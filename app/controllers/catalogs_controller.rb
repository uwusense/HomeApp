class CatalogsController < ApplicationController
  before_action :set_items, :set_category, :set_filters

  def index; end

  def filters
    filtered_items = apply_filters(@items, @filters)
    sorted_items = apply_sorting(filtered_items)

    render json: {
      items: sorted_items.map do |item|
        item.as_json.merge(username: item.user&.username)
      end
    }
  end

  private

  def set_items
    @items = Product.includes(:user).where(category: params[:tab])
  end

  def set_category
    @category = params[:tab]
  end

  def set_filters
    @filters = {
      type: params[:filter_category],
      value: params[:filter_value]
    }.compact
  end

  def set_sort_direction
    @sort_direction = params[:sort_direction] || 'newest'
  end

  def apply_filters(items, filters)
    return items unless filters[:type] == 'new_in'

    case filters[:value]
    when 'today'
      items.where('created_at >= ?', 1.day.ago)
    when 'last_7_days'
      items.where('created_at >= ?', 7.days.ago)
    when 'last_14_days'
      items.where('created_at >= ?', 14.days.ago)
    when 'all'
      items
    else
      items
    end
  end

  def apply_sorting(items)
    sort_direction = set_sort_direction
    case sort_direction
    when 'newest'
      items.order(created_at: :desc)
    when 'price_asc'
      items.order(price: :asc)
    when 'price_desc'
      items.order(price: :desc)
    when 'oldest'
      items.order(created_at: :asc)
    else
      items
    end
  end
end
