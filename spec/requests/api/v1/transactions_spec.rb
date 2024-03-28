require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  describe 'successfully places order for an item' do
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

    subject(:perform) do
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @book_1.id,
        item_type: 'book'
      }
    end

    include_examples 'creates a new object', Transaction

    it 'places the order for a book successfully' do
      perform
      expect(response).to have_http_status(:created)
      expect(@book_1.reload.quantity).to eq(4)
      expect(Transaction.last.reload.user_id).to eq(@user.id)
      expect(Transaction.last.reload.book_id).to eq(@book_1.id)
      expect(Transaction.last.reload.returned_at).to eq(nil)
      expect(Transaction.last.reload.magazine_id).to eq(nil)
    end

    subject(:perform_1) do
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @magazine_1.id,
        item_type: 'magazine'
      }
    end

    include_examples 'creates a new object', Transaction

    it 'places the order for a magazine successfully' do
      perform_1
      expect(response).to have_http_status(:created)
      expect(@magazine_1.reload.quantity).to eq(3)
      expect(Transaction.last.reload.user_id).to eq(@user.id)
      expect(Transaction.last.reload.magazine_id).to eq(@magazine_1.id)
      expect(Transaction.last.reload.returned_at).to eq(nil)
      expect(Transaction.last.reload.book_id).to eq(nil)
    end
  end

  describe 'should return different errors' do
    before(:each) do 
      subscription_plan = FactoryBot.create(:subscription_plan)
      @user = FactoryBot.create(:user)
      subscription = FactoryBot.create(:subscription, user: @user, subscription_plan: subscription_plan)
      @user.update(current_subscription_id: subscription.id)
      @user_1 = FactoryBot.create(:user)
      @book_1 = FactoryBot.create(:book, quantity: 5, genre: 'comedy')
      @book_2 = FactoryBot.create(:book, quantity: 15, genre: 'crime')
      @book_3 = FactoryBot.create(:book, quantity: 7, genre: 'business')
      @book_4 = FactoryBot.create(:book, quantity: 4, genre: 'media')
      @magazine_1 = FactoryBot.create(:magazine, quantity: 4, genre: 'comedy')
      @magazine_2 = FactoryBot.create(:magazine, quantity: 9, genre: 'horror')
    end

    it "should return email must be present" do
      post '/api/v1/transactions/place_order', params: {}
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq('Enter email id')
    end

    it "should return invalid email" do
      post '/api/v1/transactions/place_order', params: {
        email: 'abc'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq('Invalid email')
    end

    it "should return Enter item id" do
      post '/api/v1/transactions/place_order', params: {
        email: @user.email
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq('Enter item id')
    end

    it "should return Enter item type" do
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @book_1.id
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq('Enter item type')
    end

    it "should return user must suscribe first" do
      post '/api/v1/transactions/place_order', params: {
        email: @user_1.email,
        item_id: @book_1.id,
        item_type: 'book'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq(USER_MUST_SUBSCRIBE)
    end

    it "should return Exceeded monthly transaction limit" do
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      FactoryBot.create(:transaction, user: @user)
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @book_1.id,
        item_type: 'book'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq(EXCEEDED_MONTHLY_TRANSACTIONS)
    end

    it "should return user must suscribe first" do
      FactoryBot.create(:transaction, user: @user, book: @book_1)
      FactoryBot.create(:transaction, user: @user, book: @book_1)
      FactoryBot.create(:transaction, user: @user, book: @book_1)
      FactoryBot.create(:transaction, user: @user, magazine: @magazine_1)
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @book_2.id,
        item_type: 'book'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq(GOLD_PLAN_THREE_BOOKS_ONE_MAGAZINE)
    end

    it "should return user must suscribe first" do
      FactoryBot.create(:transaction, user: @user, magazine: @magazine_1)
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @magazine_2.id,
        item_type: 'magazine'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq(GOLD_PLAN_ONE_MAGAZINE)
    end

    it "should return user below 18 are not allowed crime genre" do
      @user.update(date_of_birth: '20/10/2013')
      post '/api/v1/transactions/place_order', params: {
        email: @user.email,
        item_id: @book_2.id,
        item_type: 'book'
      }
      expect(response).to have_http_status :unprocessable_entity
      expect(JSON.parse(response.body)['errors']).to eq(SHOULD_BE_ADULT)
    end
  end

  describe 'should return items successfully' do
    before(:each) do 
      subscription_plan = FactoryBot.create(:subscription_plan)
      @user = FactoryBot.create(:user)
      subscription = FactoryBot.create(:subscription, user: @user, subscription_plan: subscription_plan)
      @user.update(current_subscription_id: subscription.id)
      @user_1 = FactoryBot.create(:user)
      @book_1 = FactoryBot.create(:book, quantity: 5, genre: 'comedy')
      @book_2 = FactoryBot.create(:book, quantity: 15, genre: 'crime')
      @magazine_1 = FactoryBot.create(:magazine, quantity: 4, genre: 'comedy')
      @transaction_1 = FactoryBot.create(:transaction, user: @user, book: @book_1)
      @transaction_2 = FactoryBot.create(:transaction, user: @user, book: @book_2)
      @transaction_3 = FactoryBot.create(:transaction, user: @user, magazine: @magazine_1)
    end
   
    subject(:perform) do
      patch '/api/v1/transactions/return_items', params: {
        email: @user.email,
        transaction_ids: [@transaction_1.id, @transaction_2.id, @transaction_3.id]
      }
    end

    it "should successfully run return items apis" do
      perform
      expect(response).to have_http_status :ok
      expect(@transaction_1.reload.returned_at).not_to be_nil
      expect(@transaction_2.reload.returned_at).not_to be_nil
      expect(@transaction_3.reload.returned_at).not_to be_nil
      expect(@book_1.reload.quantity).to eq(5)
      expect(@book_2.reload.quantity).to eq(15)
    end
  end
end
