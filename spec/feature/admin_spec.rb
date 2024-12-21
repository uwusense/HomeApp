require 'rails_helper'

RSpec.describe 'Admin', type: :feature, js: true do
  let(:admin) { create(:user, :admin, username: 'admin') }
  let(:user) { create(:user) }
  let!(:product) { create_list(:product, 5, user: user) }

  describe 'when user is admin' do
    let(:users) { User.all }
    let(:products) { Product.all }

    before { login(admin) }

    it 'shows all users' do
      find('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/admin/users']").click
      end

      expect(page).to have_selector('h1', text: 'All Users')
    
      within 'table' do
        expect(page).to have_selector('th', text: 'Email')
        expect(page).to have_selector('th', text: 'Name')
        expect(page).to have_selector('th', text: 'Admin')
        expect(page).to have_selector('th', text: 'Actions')
        
        expect(page).to have_selector('tr', count: users.count + 1)
        
        users.each do |user|
          expect(page).to have_text(user.email)
          expect(page).to have_text("#{user.first_name} #{user.last_name}")
          expect(page).to have_text(user.admin ? 'Yes' : 'No')
          expect(page).to have_link('Edit', href: edit_admin_user_path(user))
        end
      end
    end
    
    it 'shows all products' do
      find('a[href="/"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/admin/products']").click
      end

      expect(page).to have_selector('h1', text: 'All Products')
    
      within 'table' do
        expect(page).to have_selector('th', text: 'Name')
        expect(page).to have_selector('th', text: 'Price')
        expect(page).to have_selector('th', text: 'Actions')
        
        expect(page).to have_selector('tr', count: products.count + 1)
        
        products.each do |product|
          expect(page).to have_text(product.name)
          expect(page).to have_text("€#{product.price}")
          expect(page).to have_link('Show', href: catalog_path(product))
          expect(page).to have_link('Edit', href: edit_admin_product_path(product))
        end
      end
    end
  end
end
