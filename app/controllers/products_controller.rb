class ProductsController < ApplicationController
  before_action :set_product, only: %i[destroy]
  before_action :authenticate_user!

  def index
    @products = current_user.products.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    ActiveRecord::Base.transaction do
      if current_user.wallet.balance >= Product::LISTING_FEE
        if @product.save
          current_user.wallet.update!(balance: current_user.wallet.balance - Product::LISTING_FEE)
          flash[:success] = t(:ok_listing, scope: 'flash')
          redirect_to catalog_path(@product) and return
        else
          flash[:alert] = t(:failed_listing, scope: 'flash')
          redirect_to new_product_path and return
        end
      else
        flash[:alert] = t(:failed_listing, scope: 'flash')
        redirect_to new_product_path and return
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:alert] = t(:failed_transaction, scope: 'flash')
    redirect_to new_product_path
  end

  def destroy
    if @product.user == current_user
      if @product.destroy
        flash[:success] = t(:ok_deleted_listing, scope: 'flash')
        redirect_to products_path
      else
        flash[:alert] = t(:failed_deleted_listing, scope: 'flash')
        redirect_back fallback_location: products_path
      end
    else
      flash[:alert] = t(:unexpected, scope: 'flash')
      redirect_back fallback_location: products_path
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t(:listing_not_found, scope: 'flash')
    redirect_to products_path
  end

  def product_params
    params.require(:product)
      .permit(:name, :price, :description, :category, :condition, :listing_type, photos: [])
      .merge(user: current_user)
  end
end
