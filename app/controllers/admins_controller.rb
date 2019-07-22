class AdminsController < ApplicationController
 before_action :authenticate_user

  def home
    if current_user.admin
      @admin = current_user
      render :admin
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def verify_admin
    if current_user.admin
      response = {status: true}
      render json: response, status: :ok
    else
      response = {status: "You need to buy a subscription"}
      render json: response, status: :unauthorized
    end
  end

  def admins
    if current_user.super_user
      @users = User.where(admin: true).order(last_logged_in: :desc).paginate(:page => params[:page], :per_page => 12)
      render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def users_stats
    if current_user.admin
      @free = Subscription.where(plan: "FREE").count
      @classic = Subscription.where(plan: "CLASSIC").count
      @custom = Subscription.where(plan: "CUSTOM").count
      @pro = Subscription.where(plan: "PRO").count
      render :stats
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  def search_users
    if current_user.admin
      args = {}

# where: { account_type: {not: ["INDIVIDUAL", "PROPERTY_OWNER"]} }
      args[:admin] = {not: true}
      args[:super_user] = {not: true}
      args[:account_type] = params[:account_type] if params[:account_type].present?
      
      args[:posts_count] = {}
      args[:posts_count][:gte] = params[:posts_count] if params[:posts_count].present?

      users = User.where(admin: false)

      query = params[:q].presence || "*"
      @users = users.search query, order: {last_logged_in: :desc}, fields: [:company, :f_name, :l_name, :email, :phone, :username], misspellings: {edit_distance: 2, below: 1},  where: args, aggs: { account_type: {}, posts_count: {} }, page: params[:page], per_page: 12
      render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end



  def search_posts
    if current_user.admin
      args = {}

      args[:type_of_property] = params[:type_of_property] if params[:type_of_property].present?
      args[:lga] = params[:lga] if params[:lga].present?
      args[:state] = params[:state] if params[:state].present?

      query = params[:q].presence || '*'

      @posts =  Post.search query, order: { created_at: :desc}, fields: [:title, :street, :lga, :state, :area, :tags, :reference_id],misspellings: {edit_distance: 2, below: 1}, where: args, aggs: { lga: {}, type_of_property: {}, state: {}}, page: params[:page], per_page: 12
      render :posts
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def reported
    if current_user.admin
      @reports = Marker.where(type_of_maker: "REPORTED" ).order(created_at: :desc).paginate(:page => params[:page], :per_page => 12)
      render :reports
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end


  # def upgrade_user
  #   if current_user.admin
  #     user = User.find_by(username: params[:id])

  #     sub = user.build_subscription(created_at: Time.now, max_post: 10, expiring_date: Time.now+30.day)
  #     if sub.save
  #       render json: { message: "Subscription created" }
  #     else
  #       render json: { message: "Subscription not created" }
  #     end
  #     UserMailer.welcome(user).deliver_later
  #   else
  #     render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
  #   end
  # end


end
