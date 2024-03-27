require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  describe 'should list available books and magazines' do
    before(:each) do
      subscription_plan = FactoryBot.create(:subscription_plan)
      @user = FactoryBot.create(:user)
      subscription = FactoryBot.create(:subscription, user: @user, subscription_plan: subscription_plan)
      @user.update(current_subscription_id: subscription.id)
      @book_1 = FactoryBot.create(:book, quantity: 5, genre: 'comedy')
      @book_2 = FactoryBot.create(:book, quantity: 15, genre: 'horror')
      @book_3 = FactoryBot.create(:book, quantity: 7, genre: 'business')
      @book_4 = FactoryBot.create(:book, quantity: 4, genre: 'media')
      @magazine_1 = FactoryBot.create(:magazine, quantity: 4, genre: 'comedy')
      @magazine_2 = FactoryBot.create(:magazine, quantity: 9, genre: 'horror')
    end

    it "should return list of books and magazies" do
      get '/api/v1/items', params: {
        email: @user.email,
        page: 1
      }
      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)['books'].count).to eq(4)
      expect(JSON.parse(response.body)['magazines'].count).to eq(2)
    end
  end
end
