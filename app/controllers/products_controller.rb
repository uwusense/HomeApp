class ProductsController < ApplicationController
  before_action :set_product, only: %i[destroy]
  before_action :authenticate_user!

  def index
    @products = current_user.products
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = 'Listing created successfully!'
      redirect_to product_path(@product)
    else
      flash[:alert] = 'Failed to create listing'
      redirect_to new_product_path
    end
  end

  def destroy
    if @product.user == current_user
      if @product.destroy
        flash[:success] = 'Listing deleted successfully!'
        redirect_to products_path
      else
        flash[:alert] = 'Failed to delete listing'
        redirect_back fallback_location: products_path
      end
    else
      flash[:alert] = 'Unexpected'
      redirect_to products_path
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Listing was not found'
    redirect_to products_path
  end

  def product_params
    params.require(:product)
          .permit(:name, :price, :description, :category, :condition, photos: [])
          .merge(user: current_user)
  end
end
