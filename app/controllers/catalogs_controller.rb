class CatalogsController < ApplicationController
  before_action :set_filters, :set_category

  def index
    set_items
    respond_to do |format|
      format.html
      format.json { render_items_as_json }
    end
  end

  private

  def set_items
    @items = Product.includes(:user).where(category: @category)
    @items = apply_filters(@items).page(params[:page]).per(3)
    @items = apply_sorting(@items)
  end

  def set_category
    @category = params[:tab]
  end

  def set_filters
    @filters = {
      date: params[:date],
      condition: params[:condition],
      sort_direction: params[:sort_direction] || 'newest',
      min_price: params[:min_price],
      max_price: params[:max_price]
    }
  end

  def apply_filters(items)
    # Date
    case @filters[:date]
    when 'today'
      items = items.where('created_at >= ?', 1.day.ago)
    when 'last_7_days'
      items = items.where('created_at >= ?', 7.days.ago)
    when 'last_14_days'
      items = items.where('created_at >= ?', 14.days.ago)
    end
    # Price range
    items = items.where('price >= ?', @filters[:min_price]) if @filters[:min_price].present?
    items = items.where('price <= ?', @filters[:max_price]) if @filters[:max_price].present?
    # Conditions
    items = items.where(condition: @filters[:condition]) if @filters[:condition].present? && @filters[:condition] != 'all'
    items
  end

  def apply_sorting(items)
    case @filters[:sort_direction]
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

  def render_items_as_json
    response = {
      items: render_to_string(partial: 'catalogs/product', collection: @items, as: :item, formats: [:html]),
      pagination: view_context.paginate(@items, remote: true)
    }
    render json: response
  end
end
