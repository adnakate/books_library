class Api::V1::UsersController < ApplicationController
  before_action :set_user

  def transactions
    transactions = @user.transactions
                        .includes(:book, :magazine)
                        .where(returned_at: nil)
                        .order('borrowed_at DESC')
                        .page params[:page]
    render json: { transactions: ActiveModel::Serializer::CollectionSerializer.new(transactions) }, status: :ok
  end

  private

  def set_user
    return render json: { errors: 'Enter email id' }, status: :unprocessable_entity if !params[:email].present?
    @user = User.where(email: params[:email]).last
    render json: { errors: 'Invalid email' }, status: :unprocessable_entity if !@user.present?
  end
end
