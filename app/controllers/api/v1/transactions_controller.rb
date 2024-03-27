class Api::V1::TransactionsController < ApplicationController
  before_action :set_user
  before_action :validate_place_order_params, only: [:place_order]
  before_action :validate_return_item_params, only: [:return_items]

  def place_order
    item = get_item
    return render json: { message: "Out of stock." }, status: :not_found if !item.present?
    can_order, message = @user.can_order_item?(item)
    if can_order
      transaction = @user.create_transaction(item)
      render json: { transaction: ActiveModelSerializers::SerializableResource.new(transaction) }, status: :created
    else
      render json: { errors: message }, status: :unprocessable_entity
    end
  end

  def return_items
    params[:transaction_ids].each do |transaction_id|
      transaction = @user.transactions.where(id: transaction_id).last
      transaction.complete_transaction
    end
    transactions = @user.transactions
                        .includes(:book, :magazine)
                        .where(id: params[:transaction_ids])
                        .order('returned_at DESC')
    render json: { transactions: ActiveModel::Serializer::CollectionSerializer.new(transactions) }, status: :ok
  end

  private

  def set_user
    return render json: { errors: 'Enter email id' }, status: :unprocessable_entity if !params[:email].present?
    @user = User.where(email: params[:email]).last
    render json: { errors: 'Invalid email' }, status: :unprocessable_entity if !@user.present?
  end

  def validate_place_order_params
    return render json: { errors: 'Enter item id' }, status: :unprocessable_entity if !params[:item_id].present?
    render json: { errors: 'Enter item type' }, status: :unprocessable_entity if !params[:item_type].present?
  end

  def get_item
    if params[:item_type] == 'book'
      Book.where(id: params[:item_id]).where('quantity > 0').last
    else
      Magazine.where(id: params[:item_id]).where('quantity > 0').last
    end
  end

  def validate_return_item_params
    if !params[:transaction_ids].present?
      return render json: { errors: 'Enter transaction ids' }, status: :unprocessable_entity
    end
  end
end
