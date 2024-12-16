require 'rails_helper'

RSpec.describe "Home", type: :feature, js: true do
  let(:user) { create(:user) }
  before { login(user) }

  describe 'when user is logged in' do
    it 'shows correct content' do
      expect(page).to have_text('YOUBUILD')
    end
  end
end
