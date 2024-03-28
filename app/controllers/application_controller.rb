class ApplicationController < ActionController::API
  before_action :set_user

  private

  def set_user
    return render json: { errors: 'Enter email id' }, status: :unprocessable_entity if !params[:email].present?
    @user = User.where(email: params[:email]).last
    render json: { errors: 'Invalid email' }, status: :unprocessable_entity if !@user.present?
  end
end
