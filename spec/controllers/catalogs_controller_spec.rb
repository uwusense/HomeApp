require 'rails_helper'

RSpec.describe CatalogsController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 3) }

    before do
      Product.reindex
      Product.search_index.refresh
      get :index
    end

    it 'response is successful' do
      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end

    it 'renders index' do
      expect(response).to render_template('index')
    end

    it 'loads all of the products into @items' do
      expect(assigns(:items)).to match_array(products)
    end
  end

  describe 'GET #show' do
    context 'when product exists' do
      let(:product) { create(:product) }

      it 'response is successful' do
        get :show, params: { id: product.id }
        expect(response).to be_successful
      end

      it 'renders show' do
        get :show, params: { id: product.id }
        expect(response).to render_template('show')
      end
    end

    context 'when the product does not exist' do
      it 'redirects to index with error message' do
        get :show, params: { id: 99_999 }
        expect(response).to redirect_to(catalogs_path)
        expect(flash[:error]).to match(/Item not found/)
      end
    end
  end
end
