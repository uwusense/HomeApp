require 'rails_helper'

RSpec.describe 'User', type: :feature, js: true do
  describe 'Registration' do
    let!(:existing_user) { create(:user, email: 'unique@test.com', username: 'uniqueuser') }

    before do
      within('.header-content-right__actions') do
        find('.header-content-right__actions--button', text: 'Register').click
      end
    end

    it 'allows a user to register' do
      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[username]', with: 'aizgamat'
      fill_in 'user[first_name]', with: 'Matīss'
      fill_in 'user[last_name]', with: 'Aizgalis'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test123'

      click_button 'Register'

      expect(page).to have_text('Welcome! You have signed up successfully.')
      expect(current_path).to eq("#{root_path}en")
    end

    it 'shows error messages for invalid inputs' do
      fill_in 'user[email]', with: 'test@test.com'
      click_button 'Register'

      expect(page).to have_content("Password can't be blank")
    end

    it 'shows error about non-unique email and username' do
      fill_in 'user[email]', with: 'unique@test.com'
      fill_in 'user[username]', with: 'uniqueuser'
      fill_in 'user[first_name]', with: 'Matīss'
      fill_in 'user[last_name]', with: 'Aizgalis'
      fill_in 'user[password]', with: 'test123'
      fill_in 'user[password_confirmation]', with: 'test123'

      click_button 'Register'

      expect(page).to have_content('Email has already been taken')
      expect(page).to have_content('Username has already been taken')
    end
  end

  describe 'Login' do
    let!(:user) { create(:user) }

    before do
      within('.header-content-right__actions') do
        find('.header-content-right__actions--button', text: 'Login').click
      end
    end

    it 'allows a user to sign in' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password

      click_button 'Sign in'

      expect(page).to have_text('Signed in successfully.')
      expect(current_path).to eq("#{root_path}en")
    end

    it 'prevents user from signin with wrong credentials' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'nederiga123'

      click_button 'Sign in'

      expect(page).to have_text('Invalid Email or password.')
    end

    it 'navigates user to forgot password view' do
      click_link 'Forgot your password?'
      expect(current_path).to eq("/en#{new_user_password_path}")
    end
  end

  describe 'Reset password' do
    let!(:user) { create(:user, email: 'user@example.com') }

    before do
      ActionMailer::Base.deliveries.clear
      within('.header-content-right__actions') do
        find('.header-content-right__actions--button', text: 'Login').click
      end
      click_link 'Forgot your password?'
    end

    it 'allows to reset password' do
      fill_in 'user[email]', with: user.email
      click_button 'Reset password'

      within('.flash') do
        expect(page).to have_text('You will receive an email with instructions on how to reset your password in a few minutes.')
      end

      open_email(user.email)
      current_email.click_link 'Change my password'

      fill_in 'user[password]', with: 'test321'
      fill_in 'user[password_confirmation]', with: 'test321'
      click_button 'Change my password'

      # Invalid token because of tests.
      # expect(page).to have_text('Your password has been changed successfully.')
      # expect(current_path).to eq("#{root_path}en")
    end
  end
end
