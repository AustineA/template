class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :agents, :purpose]
  before_action :authenticate_user, only: [:update, :show]

  def index
    
  end
  
  def create
    user = User.new(user_params)
    if user.save
      # auth_token = Knock::AuthToken.new payload: { sub: user.id, email: user.email, name: user.f_name }
      # UserMailer.welcome(user).deliver_later
      # render json: auth_token, status: :created
    else
        render json:   { message: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def show

  end

  def agents
    render :agent
  end

  def search_agents
    only_agents = User.where.not(account_type: "INDIVIDUAL")
    if query = params[:q].presence 
      @agents = User.search query, fields: [:company, :f_name, :l_name, :email, :phone], misspellings: {edit_distance: 1, below: 2}, where: { account_type: {not: "INDIVIDUAL"} } 
    else
      @agents = only_agents
    end
    render :agents
  end

  def purpose
    p = params[:q]
    @posts = @user.posts.where(purpose: p)
  end

  def update
    @user = current_user

    if params[:user][:avatar].present?
      @user.avatar.purge
      @user.avatar.attach(params[:avatar])
    end

    if @user.update!(user_params)
      render :show
    else
      render json: { message: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
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
    @user = User.find_by_username(params[:id])
  end

  def user_params
    params.require(:user).permit(:f_name, :l_name, :avatar, :username, :email, :password, :phone, :about, :company, :account_type, address:[:state, :city, :street])
  end
end
