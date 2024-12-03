class CatalogsController < ApplicationController
  before_action :set_filters, :set_category

  def index
    set_items
    respond_to do |format|
      format.html
      format.json { render_items_as_json }
    end
  end

  def show
    @item = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Item not found'
    redirect_to catalogs_path
  end

  private

  def set_items
    query_conditions = apply_filters

    if query.present?
      @items = Product.search(query, where: query_conditions, includes: [:user], page: params[:page], per_page: 20)
    elsif @category == 'new_in'
      @items = Product.search("*", where: query_conditions, includes: [:user], page: params[:page], per_page: 20)
    else
      @items = Product.search("*", where: query_conditions, includes: [:user], page: params[:page], per_page: 20)
    end
    Rails.logger.debug "@items: #{@items}"
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
      max_price: params[:max_price],
      query: params[:query]
    }
  end

  def apply_filters
    query_conditions = {}
    query_conditions[:category] = @category if @category && @category != 'new_in'

    if @filters[:date].present?
      case @filters[:date]
      when 'today'
        query_conditions[:created_at] = { gte: 1.day.ago }
      when 'last_7_days'
        query_conditions[:created_at] = { gte: 7.days.ago }
      when 'last_14_days'
        query_conditions[:created_at] = { gte: 14.days.ago }
      end
    end

    query_conditions[:price] = {}
    query_conditions[:price][:gte] = @filters[:min_price].to_f if @filters[:min_price].present?
    query_conditions[:price][:lte] = @filters[:max_price].to_f if @filters[:max_price].present?

    query_conditions[:condition] = @filters[:condition] if @filters[:condition].present? && @filters[:condition] != 'all'

    query_conditions
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

  def query
    params[:query]
  end
end
