require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, user:) }

  before { sign_in user }

  describe 'GET #index' do
    it 'assigns @products' do
      get :index
      expect(assigns(:products)).to eq(user.products.order(created_at: :desc).page(1).per(5))
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a product' do
        expect do
          post :create, params: { product: attributes_for(:product) }
        end.to change(Product, :count).by(1)
        expect(response).to redirect_to(catalog_path(assigns(:product)))
      end
    end

    context 'with insufficient balance' do
      it 'doesnt create a product, redirects to new product path' do
        allow_any_instance_of(Wallet).to receive(:balance).and_return(0)
        expect do
          post :create, params: { product: attributes_for(:product) }
        end.not_to change(Product, :count)
        expect(response).to redirect_to(new_product_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys product' do
      product = create(:product, user:)
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)
      expect(response).to redirect_to(products_path)
    end

    it 'redirects to products path and flash error' do
      delete :destroy, params: { id: 99_999 }
      expect(flash[:error]).to match(/Listing was not found/)
      expect(response).to redirect_to(products_path)
    end
  end
end
