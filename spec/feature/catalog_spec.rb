require 'rails_helper'

RSpec.describe "Catalog", js: true do
  let!(:user) { create(:user) }

  before do
    create_list(:product, 2, price: 50, user: user, condition: 'used')
    create_list(:product, 1, price: 100, user: user, condition: 'new', name: 'Expensive one')
    login(user)
    visit catalogs_path(tab: 'doors_windows')
  end

  describe 'filters'do
    it 'allows users to filter products by price' do
      within('.catalog_filters_wrapper') do
        fill_in 'min_price', with: '25'
        fill_in 'max_price', with: '75'
      end

      expect(page).to have_css('.catalog_item', count: 2)
    end

    it 'allows users to filter products by condition' do
      within('.catalog_filters_wrapper') do
        find('.catalog_filters_condition_option[data-filter-condition="new"]').click
      end

      expect(page).to have_css('.catalog_item', count: 1)
      expect(page).to have_content('New')
    end

    it 'allows users to filter products by days' do
      within('.catalog_filters_new_in_options') do
        find('.catalog_filters_new_in__option[data-filter-date="today"]').click
      end
      expect(page).to have_css('.catalog_item', count: 3)

      within('.catalog_filters_new_in_options') do
        find('.catalog_filters_new_in__option[data-filter-date="last_7_days"]').click
      end
      expect(page).to have_css('.catalog_item', count: 0)

      within('.catalog_filters_new_in_options') do
        find('.catalog_filters_new_in__option[data-filter-date="last_14_days"]').click
      end
      expect(page).to have_css('.catalog_item', count: 0)
    end
  end

  describe 'favorites' do
    it 'allows a user to favorite and unfavorite a product' do
      expect(user.reload.favorited_products.count).to eq(0)

      within("#items_list") do
        first('.favorite_icon').click
      end
      expect(page).to have_css('.favorite_icon--favorited')
      expect(user.reload.favorited_products.count).to eq(1)

      within("#items_list") do
        find('.favorite_icon--favorited').click
      end
      expect(page).to have_css('.favorite_icon')
      expect(user.reload.favorited_products.count).to eq(0)
    end
  end

  describe 'show' do
    let(:product) { Product.where(name: 'Expensive one').first }

    it 'displays the product details' do
      find('.catalog_item__title', text: product.name).click
      expect(page).to have_current_path(catalog_path(product.id))
      within('.main_product_wrapper') do
        expect(page).to have_content(product.name)
        expect(page).to have_content(product.description)
        expect(page).to have_content("€#{product.price}")
        expect(page).to have_button('Contact with seller')
      end
    end
  end
end
