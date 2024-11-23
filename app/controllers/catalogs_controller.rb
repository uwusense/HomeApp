class CatalogsController < ApplicationController
  before_action :set_items, :set_category

  def index;end

  def filters
    filtered_items = @items
      .then { |items| apply_filters(items) }
      .then { |items| apply_sorting(items) }
      .then { |items| apply_price_range(items) }

      render json: { items: filtered_items.map { |item| item.as_json.merge(username: item.user&.username) } }
  end

  private

  def set_items
    @items = Product.includes(:user).where(category: params[:tab])
    @items = apply_sorting(@items)
  end

  def set_category
    @category = params[:tab]
  end

  def set_filters
    {
      type: params[:filter_category],
      value: params[:filter_value]
    }
  end

  def apply_filters(items)
    filters = set_filters
    return items unless filters[:type] == 'new_in'

    filtered_items = case filters[:value]
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

    filtered_items
  end

  def apply_sorting(items)
    sort_direction = params[:sort_direction] || 'newest'
    sorted_items = case sort_direction
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
    sorted_items
  end

  def apply_price_range(items)
    return unless items

    items = items.where('price >= ?', params[:min_price]) if params[:min_price].present?
    items = items.where('price <= ?', params[:max_price]) if params[:max_price].present?
    items
  end
end
