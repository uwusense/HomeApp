class CatalogController < ApplicationController
  before_action :set_items, :set_filters

  def index
    #@items = apply_filters(@items, @filters)
    @items
  end

  private

  def set_items
    @items = Product.where(category: params[:tab])
    @items = sort_items(@items, params[:sort]) if params[:sort]
  end

  def sort_items(items, sort_param)
    case sort_param
    when 'newest'
      items.sort_by { |item| item[:created_at] }.reverse
    when 'price_asc'
      items.sort_by { |item| item[:price] }
    when 'price_desc'
      items.sort_by { |item| -item[:price] }
    when 'oldest'
      items.sort_by { |item| item[:created_at] }
    else
      items
    end
  end

  def set_filters
    @filters = {
      new_in: params[:new_in],
      price: params[:price],
      condition: params[:condition],
      availability: params[:availability]
    }.compact
  end

  def apply_filters(items, filters)
    if filters[:new_in]
      case filters[:new_in]
      when 'today'
        items = items.where('created_at >= ?', 1.day.ago)
      when 'last_7_days'
        items = items.where('created_at >= ?', 7.days.ago)
      when 'last_14_days'
        items = items.where('created_at >= ?', 14.days.ago)
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: { items: @items.map(&:as_json) } }
    end
  end
end
