require 'rails_helper'

RSpec.describe "ChatRooms", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/chat_rooms/index"
      expect(response).to have_http_status(:success)
    end
  end

end
