require 'rails_helper'

RSpec.describe FavoriteProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns correct instance and renders to index' do
      user.favorited_products << product
      get :index
      expect(assigns(:fav_products)).to eq(user.favorited_products)
      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do
    it 'adds a product to favorites and redirects back' do
      post :create, params: { product_id: product.id }
      expect(user.favorited_products).to include(product)
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'DELETE #destroy' do
    before { user.favorited_products << product }

    it 'removes a product from favorites and redirects back' do
      delete :destroy, params: { id: product.id }
      expect(user.favorited_products).not_to include(product)
      expect(response).to redirect_to(root_path)
    end
  end
end
