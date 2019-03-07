class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:update]

  def index
    
  end
  
  def create
    user = User.new(user_params)
    if user.save
      # auth_token = Knock::AuthToken.new payload: { sub: user.id, email: user.email, name: user.f_name }
      # UserMailer.welcome(user).deliver_later
      # render json: auth_token, status: :created
    else
        render json: user.errors, status: :unprocessable_entity
    end
  end

  def show

  end

  def update
    if @user.update!(user_params)
      response = { message: "User updated successfully" }
      render json: response
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

 def iforgot
    @user = User.find_by(email: params[:user][:email])
    if @user.present?
      temp_password = SecureRandom.hex(10)
      @user.update!(:password => temp_password )
      # UserMailer.iforgot_email(@user, temp_password).deliver_later
      response = { message: "An email has been sent to your email" }
      render json: response, status: :ok
    else
      response = { message: "#{params[:user][:email]} doesn't exist. Please enter a valid email" }
      render json: response, status: :unprocessable_entity
    end
  end





  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:f_name, :l_name, :username, :email, :password)
  end
end
