class ForumsController < ApplicationController
  before_action :set_forum, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:index]
  
  def index
    @forums = Forum.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 8)
  end

  def show
  end

  def create
    @forum = current_user.forums.build(forum_params)

    if @forum.save
      render :show, status: :created
    else
      render json: @forum.errors, status: :unprocessable_entity
    end
  end


  def update
    if @forum.user == current_user || current_user.admin
      if @forum.update(forum_params)
        render :show
      else
        render json: @forum.errors, status: :unprocessable_entity
      end
    else
      render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end


  def destroy
    if @forum.user == current_user || current_user.admin
      @forum.destroy
    else
        render json:   { message: "You're not authorized to carry out this action" }, status: :unauthorized
    end
  end

  private
  def set_forum
    @forum = Forum.find_by_permalink(params[:id])
  end

  def forum_params
    params.require(:forum).permit(:body, :subject, :category)
  end
end
