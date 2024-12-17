class FavoriteProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @fav_products = current_user.favorited_products.page(params[:page]).per(5)
  end

  def create
    @product = Product.find(params[:product_id])
    if current_user.favorited_products << @product
      flash[:notice] = 'Product added to favorites'
    else
      flash[:alert] = 'Couldnt add product to favorites'
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @favorite = current_user.favorite_products.find_by(product_id: params[:id])
    if @favorite&.destroy
      flash[:notice] = 'Product removed from favorites successfully'
    else
      flash[:alert] = 'Couldnt remove product from favorites'
    end
    redirect_back(fallback_location: root_path)
  end
end
