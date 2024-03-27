require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe 'should list books and magazies actively borrowed by user' do
    before(:each) do
      subscription_plan = FactoryBot.create(:subscription_plan)
      @user = FactoryBot.create(:user)
      subscription = FactoryBot.create(:subscription, user: @user, subscription_plan: subscription_plan)
      @user.update(current_subscription_id: subscription.id)
      @book_1 = FactoryBot.create(:book, quantity: 5, genre: 'comedy')
      @book_2 = FactoryBot.create(:book, quantity: 15, genre: 'horror')
      @magazine_1 = FactoryBot.create(:magazine, quantity: 4, genre: 'comedy')
      @transaction_1 = FactoryBot.create(:transaction, user: @user, book: @book_1)
      @transaction_2 = FactoryBot.create(:transaction, user: @user, book: @book_2)
      @transaction_3 = FactoryBot.create(:transaction, user: @user, magazine: @magazine_1)
    end

    it "should return list of transactions with actively borrowed books and magazines" do
      get '/api/v1/users/transactions', params: {
        email: @user.email,
        page: 1
      }
      expect(response).to have_http_status :ok
      expect(JSON.parse(response.body)['transactions'].count).to eq(3)
    end
  end
end
