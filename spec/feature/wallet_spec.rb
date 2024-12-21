require 'rails_helper'

RSpec.describe 'Wallet', type: :feature, js: true do
  let(:user) { create(:user) }

  describe 'when user is authorized' do
    before { login(user) }

    it 'can top up wallet' do
      within('.header__wallet') do
        expect(page).to have_css('.header__wallet_amount', text: '€10,000.00')
      end

      find('.header__wallet').click

      within('.wallet__balance') do
        expect(page).to have_content('Balance: €10,000.00')
      end

      within('.wallet_form') do
        expect(page).to have_selector("input[type='radio']", count: 2)
        expect(page).to have_field('Amount')
        expect(page).to have_button('Add funds')
      end

      within('.wallet_form') do
        choose 'Citadele'
        fill_in 'Amount', with: '20.00'
        click_button 'Add funds'
      end

      expect(page).to have_content('Balance: €10,020.00')

      within('table') do
        expect(page).to have_selector('th', text: 'Type')
        expect(page).to have_selector('th', text: 'Amount')
        expect(page).to have_selector('th', text: 'Date')
        expect(page).to have_selector('tr', count: 2)
      end

      expect(page).to have_text('Citadele')
      expect(page).to have_text(20)
    end
  end
end
