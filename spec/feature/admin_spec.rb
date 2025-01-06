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
      find('a[href="/en"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/en/admin/users']").click
      end

      expect(page).to have_selector('h1', text: 'All users')
    
      within 'table' do
        expect(page).to have_selector('th', text: 'Email')
        expect(page).to have_selector('th', text: 'Name')
        expect(page).to have_selector('th', text: 'Admin')
        expect(page).to have_selector('th', text: '')
        
        expect(page).to have_selector('tr', count: users.count + 1)
        binding.pry
        users.each do |user|
          expect(page).to have_text(user.email)
          expect(page).to have_text("#{user.first_name} #{user.last_name}")
          expect(page).to have_text(user.admin ? 'Yes' : 'No')
          expect(page).to have_link('Edit', href: "/en#{edit_admin_user_path(id: user.id)}")
        end
      end
    end

    it 'allows admin to edit user details' do
      visit admin_users_path

      within 'table' do
        user_to_edit = users.first
        find("a[href='/en#{edit_admin_user_path(id: user_to_edit.id)}']").click
      end

      expect(page).to have_selector('h1', text: 'Edit user')

      fill_in 'Email', with: 'matiss0303@gmail.com'
      fill_in 'First name', with: 'Matīss'
      fill_in 'Last name', with: 'Aizgalis'
      check 'Admin'
      click_button 'Update'

      expect(page).to have_current_path("/en#{edit_admin_user_path(id: users.first.id)}")
      expect(page).to have_text('User updated successfully')
    end
    
    it 'shows all products' do
      find('a[href="/en"][data-toggle-button="#profile_menu_box"][data-toggle-class=".profile_menu--active"]').click

      within('#profile_menu_box') do
        find("a[href='/en/admin/products']").click
      end

      expect(page).to have_selector('h1', text: 'All products')
    
      within 'table' do
        expect(page).to have_selector('th', text: 'Name')
        expect(page).to have_selector('th', text: 'Price')
        expect(page).to have_selector('th', text: '')
        
        expect(page).to have_selector('tr', count: products.count + 1)
        
        products.each do |product|
          expect(page).to have_text(product.name)
          expect(page).to have_text("€#{product.price}")
          expect(page).to have_link('Show', href: "/en#{catalog_path(id: product)}")
          expect(page).to have_link('Edit', href: "/en#{edit_admin_product_path(id: product.id)}")
        end
      end
    end

    it 'allows admin to edit product details' do
      visit admin_products_path

      within 'table' do
        product_to_edit = products.first
        find("a[href='/en#{edit_admin_product_path(id: product_to_edit.id)}']").click
      end

      expect(page).to have_selector('h1', text: 'Edit product')

      fill_in 'product[name]', with: 'Testa produkts'
      fill_in 'product[price]', with: '150.50'
      click_button 'Update'

      expect(page).to have_current_path("/en#{edit_admin_product_path(id: products.first.id)}")
      expect(page).to have_text('Product updated successfully')
    end
  end
end
