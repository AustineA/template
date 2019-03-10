class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user, except: [:show, :index]


  def index
    @posts = Post.all
    render json: PostSerializer.new(@posts)
  end

  def show
    render json: PostShowSerializer.new(@post)
  end


  def create
    @user = current_user
    @post = current_user.posts.build(post_params)
      if @post.save
          render :show, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end

  end


    def update

        if @post.update!(post_params)
          render :show

        else
          render json: @post.errors, status: :unprocessable_entity
        end

    end


    def destroy
      @post.destroy
    end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_permalink(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:price, :duration, :street,:lga,:state, :title, :purpose, :use_of_property, :sub_type_of_property, :bedrooms, :bathrooms, :toliets, :description, :video_link )
    end

end
