class Api::V1::ItemsController < ApplicationController
  def index
    books = Book.order('title').page params[:page]
    magazines = Magazine.order('title').page params[:page]
    render json: { books: ActiveModel::Serializer::CollectionSerializer.new(books, scope: @user),
                   magazines: ActiveModel::Serializer::CollectionSerializer.new(magazines, scope: @user) }, status: :ok
  end
end
