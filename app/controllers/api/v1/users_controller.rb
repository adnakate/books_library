class Api::V1::UsersController < ApplicationController
  def transactions
    transactions = @user.transactions
                        .includes(:book, :magazine)
                        .where(returned_at: nil)
                        .order('borrowed_at DESC')
                        .page params[:page]
    render json: { transactions: ActiveModel::Serializer::CollectionSerializer.new(transactions) }, status: :ok
  end
end
