class Api::V1::ItemsController < ApplicationController
  before_action :set_user

  def index
    books = Book.order('title').page params[:page]
    magazines = Magazine.order('title').page params[:page]
    render json: { books: ActiveModel::Serializer::CollectionSerializer.new(books, scope: @user),
                   magazines: ActiveModel::Serializer::CollectionSerializer.new(magazines, scope: @user) }, status: :ok
  end

  private

  def set_user
    return render json: { errors: 'Enter email id' }, status: :unprocessable_entity if !params[:email].present?
    @user = User.where(email: params[:email]).last
    render json: { errors: 'Invalid email' }, status: :unprocessable_entity if !@user.present?
  end
end
