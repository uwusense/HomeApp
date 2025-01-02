class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @products = Product.all.order(created_at: :desc).page(params[:page]).per(20)
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to [:admin, @product], notice: t(:product_updated, scope: 'flash')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, :condition)
  end
end
