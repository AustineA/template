class AdminsController < ApplicationController


  def home
    if current_user.admin
      @admin = current_user
      render :admin
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

      args[:account_type] = params[:account_type] if params[:account_type].present?
      args[:posts_count] = {}
      args[:posts_count][:gte] = params[:posts_count] if params[:posts_count].present?

      users = User.where(admin: false)

      if  query = params[:q].presence
        @users = users.search query, order: {last_logged_in: :desc}, fields: [:company, :f_name, :l_name, :email, :phone, :username], misspellings: {edit_distance: 3, below: 2},  where: args, aggs: { account_type: {}, posts_count: {} }, page: params[:page], per_page: 12
      else
        @users = users.order(last_logged_in: :desc).paginate(:page => params[:page], :per_page => 12)
      end
        render :users
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end



  def search_posts
    if current_user.admin
      args[:type_of_property] = params[:type_of_property] if params[:type_of_property].present?
      args[:lga] = params[:lga] if params[:lga].present?
      args[:state] = params[:state] if params[:state].present?

      @posts =  Post.search query, order: { created_at: :desc}, fields: [:title, :street, :lga, :state, :area, :tags, :reference_id],misspellings: {edit_distance: 2, below: 1}, where: args, aggs: { lga: {}, type_of_property: {}, state: {}}, page: params[:page], per_page: 8
      render :posts
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end

  def reported
    if current_user.admin
      @posts = Post.order(created_at: :desc)
      render :posts
    else
      render json:   { message: "You're not authorized to access this resource" }, status: :unauthorized
    end
  end



end
