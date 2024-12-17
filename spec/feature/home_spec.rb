require 'rails_helper'

RSpec.describe "Home", type: :feature, js: true do
  let(:user) { create(:user) }
  let!(:product) { create(:product, user: user) }

  before { login(user) }

  describe 'when user is logged in' do
    it 'shows correct content' do
      within('.header__logo') { expect(page).to have_text('YOUBUILD') }
      within('.header-content') do
        expect(page).to have_field(
          'query',
          with: nil,
          placeholder: 'Search pre-owned furniture & building materials',
          type: 'search'
        )
      end

      within('.header-content-right') do
        expect(page).to have_link('Start selling', href: '/products/new', class: 'header-content-right__selling')
        expect(page).to have_selector('a[href="/"] i.icon-star')
        expect(page).to have_selector('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"] i.icon-person')
      end
    end

    it 'has newest items' do
      within('.scroll_menu_wrapper') do
        expect(page).to have_css('.scroll_menu_item', count: 1)
        within('.scroll_menu_item') do
          expect(page).to have_css('.scroll_menu_item__photo')
          expect(page).to have_css('.scroll_menu_item__price', text: "€#{product.price}")
          expect(page).to have_css('.scroll_menu_item__seller', text: user.username)
        end
      end
    end
  end
end
