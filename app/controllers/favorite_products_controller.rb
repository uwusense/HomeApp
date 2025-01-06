class FavoriteProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @fav_products = current_user.favorited_products.page(params[:page]).per(20)
  end

  def create
    @product = Product.find(params[:product_id])
    if current_user.favorited_products << @product
      flash[:notice] = t(:ok_favorite_prod, scope: 'flash')
    else
      flash[:alert] = t(:failed_favorite_prod, scope: 'flash')
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @favorite = current_user.favorite_products.find_by(product_id: params[:id])
    if @favorite&.destroy
      flash[:notice] = t(:ok_remove_favorite_prod, scope: 'flash')
    else
      flash[:alert] = t(:failed_remove_favorite_prod, scope: 'flash')
    end
    redirect_back(fallback_location: root_path)
  end
end
