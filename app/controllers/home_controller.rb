class HomeController < ApplicationController
  def index
    @newest_items = Product.includes(:user).newest_first.limit(30)
  end
end
