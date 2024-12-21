require 'rails_helper'

RSpec.describe "Home", type: :feature, js: true do
  describe 'when regular user' do
    let(:user) { create(:user) }
    let!(:product) { create(:product, user: user) }

    before { login(user) }

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
        expect(page).to have_selector('a[href="/favorite_products"] i.icon-star')
        expect(page).to have_selector('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"] i.icon-person')
        expect(page).to have_selector('a[href="/chat_rooms"] i.icon-bubble')
        expect(page).to have_no_link('Login', href: '/users/sign_in')
        expect(page).to have_no_link('Register', href: '/users/sign_up')
        expect(page).to have_button('Logout')
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

  describe 'when admin user' do
    let(:user) { create(:user, :admin) }

    before { login(user) }

    it 'shows appropriate options under profile UI' do
      find('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        expect(page).to have_css('div.profile_menu__content')
        expect(page).to have_link('My listings', href: '/products')
        expect(page).to have_link('Users - admin view', href: '/admin/users')
        expect(page).to have_link('Products - admin view', href: '/admin/products')
      end
    end
  end

  describe 'when unauthorized user' do
    it 'shows appropriate content' do
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
        expect(page).to have_no_selector('a[href="/favorite_products"] i.icon-star')
        expect(page).to have_no_selector('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"] i.icon-person')
        expect(page).to have_no_selector('a[href="/chat_rooms"] i.icon-bubble')
        expect(page).to have_link('Login', href: '/users/sign_in')
        expect(page).to have_link('Register', href: '/users/sign_up')
      end
    end
  end
end
