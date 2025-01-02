require 'rails_helper'

RSpec.describe "Product", type: :feature, js: true do
  let(:user) { create(:user) }
  let!(:product) { create(:product, user: user) }

  describe 'when user is logged in' do
    before { login(user) }

    it 'shows current existing product in categories' do
      within('.navigation__wrapper') do
        click_on I18n.t('doors_windows', scope: 'categories')
      end

      within('.catalog_items_wrapper') do
        expect(page).to have_css('.catalog_item')

        within('.catalog_item') do
          expect(page).to have_css('.catalog_item__photo')
          expect(page).to have_css('.catalog_item__title', text: product.name)
          expect(page).to have_css('.catalog_item__price', text: "€#{product.price}")
          expect(page).to have_css('.catalog_item__seller', text: user.username)
        end
      end
    end

    it 'displays correct form fields' do
      within('.header-content-right') do
        click_on I18n.t(:start_selling, scope: 'header')
      end

      expect(current_path).to eq("/en#{new_product_path}")
      expect(page).to have_selector('h1', text: 'Create a Product')

      expect(page).to have_field('product[name]')
      expect(page).to have_field('product[price]')
      expect(page).to have_field('product[description]')
      # expect(page).to have_select('Condition', options: ['Select a condition'] + Product::CONDITIONS.map { |c| I18n.t(c, scope: 'products') })
      # expect(page).to have_select('Category', options: ['Select a category'] + Product::CATEGORIES.map { |c| I18n.t(c, scope: 'categories') })
      expect(page).to have_css('input[type="file"][accept="image/png,image/jpg,image/jpeg"]')
      expect(page).to have_button('Create listing for 0.30 €')
    end

    it 'displays error messages' do
      within('.header-content-right') do
        click_on I18n.t(:start_selling, scope: 'header')
      end

      click_button 'Create listing for 0.30 €'
      expect(page).to have_css('.flash', text: 'Failed to create listing')
    end

    it 'creates a product successfully' do
      within('.header-content-right') do
        click_on I18n.t(:start_selling, scope: 'header')
      end

      fill_in 'product[name]', with: 'Sample Product'
      fill_in 'product[price]', with: '19.99'
      fill_in 'product[description]', with: 'This is a test product description.'
      all('.select2-container')[0].click
      find('.select2-results__option', text: 'New').click
      all('.select2-container')[1].click
      find('.select2-results__option', text: 'Doors & Windows').click
      all('.select2-container')[2].click
      find('.select2-results__option', text: 'Sell').click
      attach_file('Photos', Rails.root.join('spec/files/sample_image.jpg'))

      expect { click_button 'Create listing for 0.30 €' }.to change { Product.count }.by(1)
      expect(page).to have_current_path("/en#{catalog_path(id: Product.last.id)}")
      expect(page).to have_css('.flash', text: 'Listing created successfully!')

      within('.content') do
        expect(page).to have_text(Product.last.name)
        expect(page).to have_text(Product.last.description)
        expect(page).to have_text(Product.last.price)
      end

      find('a[href="/en"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/en/products']").click
      end

      expect(page).to have_text('Your products')
      expect(page).to have_selector('.product_list table tbody tr', count: 2)
      within('.product_list table tbody') do
        expect(page).to have_text('Sample Product', count: 2)
        expect(page).to have_text('€19.99')
        expect(page).to have_text('This is a test product description.')
        expect(page).to have_text('Doors & Windows')
        expect(page).to have_text('New')
      end

      accept_confirm do
        first('.default_button--red').click
      end

      expect(page).to have_text('Sample Product', count: 1)
    end

    it 'deletes product successfully' do
      find('a[href="/en"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/en/products']").click
      end

      expect { accept_confirm { click_button 'Delete' } }.to change { Product.count }.by(-1)
      expect(page).to have_css('.flash', text: I18n.t(:ok_deleted_listing, scope: 'flash'))

    end

    it 'cant create product due to insufficent wallet balance' do
      allow_any_instance_of(Wallet).to receive(:balance).and_return(0.29)

      within('.header-content-right') do
        click_on I18n.t(:start_selling, scope: 'header')
      end

      fill_in 'product[name]', with: 'Sample Product'
      fill_in 'product[price]', with: '19.99'
      fill_in 'product[description]', with: 'This is a test product description.'
      all('.select2-container')[0].click
      find('.select2-results__option', text: 'New').click
      all('.select2-container')[1].click
      find('.select2-results__option', text: 'Doors & Windows').click
      all('.select2-container')[2].click
      find('.select2-results__option', text: 'Sell').click
      attach_file('Photos', Rails.root.join('spec/files/sample_image.jpg'))

      expect { click_button 'Create listing for 0.30 €' }.to change { Product.count }.by(0)
      expect(page).to have_css('.flash', text: 'Failed to create listing')
    end
  end

  describe 'when user is not logged in' do
    it 'shows current existing products in categories' do
      within('.navigation__wrapper') do
        click_on I18n.t('doors_windows', scope: 'categories')
      end

      within('.catalog_items_wrapper') do
        expect(page).to have_css('.catalog_item')

        within('.catalog_item') do
          expect(page).to have_css('.catalog_item__photo')
          expect(page).to have_css('.catalog_item__title', text: product.name)
          expect(page).to have_css('.catalog_item__price', text: "€#{product.price}")
          expect(page).to have_css('.catalog_item__seller', text: user.username)
        end
      end
    end

    it 'cant create a new product and redirects to login' do
      within('.header-content-right') do
        click_on I18n.t(:start_selling, scope: 'header')
      end
      expect(page).to have_css('.flash', text: I18n.t(:sign_in, scope: 'flash'))
      expect(current_path).to eq("/en#{new_user_session_path}")
    end
  end
end
