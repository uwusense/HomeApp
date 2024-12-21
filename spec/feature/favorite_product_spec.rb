require 'rails_helper'

RSpec.describe "Favorite product", js: true do
  let!(:user) { create(:user) }

  before do
    create_list(:product, 2, price: 50, user: user, condition: 'used')
    create_list(:product, 1, price: 100, user: user, condition: 'new', name: 'Expensive one')
    login(user)
    visit favorite_products_path
  end

  describe 'favorite products' do
    it 'Shows appropriate information' do
      expect(page).to have_no_css('catalog_item')

      visit catalogs_path(tab: 'doors_windows')
      expect(user.reload.favorited_products.count).to eq(0)

      within("#items_list") do
        first('.favorite_icon').click
      end
      expect(page).to have_css('.favorite_icon--favorited')
      expect(user.reload.favorited_products.count).to eq(1)

      visit favorite_products_path
      expect(page).to have_css('.catalog_item')

      within('.catalog_item') do
        find('.favorite_icon--favorited').click
      end
      expect(page).to have_no_css('.catalog_item')
      expect(user.reload.favorited_products.count).to eq(0)

      visit catalogs_path(tab: 'doors_windows')
      expect(page).to have_no_css('.favorite_icon--favorited')
    end
  end
end
