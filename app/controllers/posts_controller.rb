class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user, except: [:show, :index, :search]


  def index
    @posts = Post.all
    render :index
  end

  def show
    render :show
  end

  def search
    args = {}

    args[:price] = {}
    args[:price][:gte] = params[:min_price] if params[:min_price].present?
    args[:price][:lte] = params[:max_price] if params[:max_price].present?


    args[:bedrooms] = {}
    args[:bedrooms][:gte] = params[:min_bedrooms] if params[:min_bedrooms].present?
    args[:bedrooms][:lte] = params[:max_bedrooms] if params[:max_bedrooms].present?

    args[:purpose] = params[:purpose] if params[:purpose].present?
    args[:sub_type_of_property] = params[:sub_type_of_property] if params[:sub_type_of_property].present?
    query = params[:q].presence || "*"

    @posts =  Post.search query, fields: [:title, :street, :lga, :state],misspellings: {edit_distance: 2, below: 1}, where: args, aggs: { purpose: {}, sub_type_of_property: {}, price: {}, bedrooms: {}}
    render :index

  end

  def create
    @user = current_user
    @post = current_user.posts.build(post_params)
    @post.images.attach(params[:images]) if params[:images].present?
      if @post.save
          render :created, status: :created
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

  def delete_image_attachment
    @delete_image = ActiveStorage::Attachment.find(params[:id])
    if @delete_image.purge
      render json: "Deleted"
    else
      render json: @delete_image.errors
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by_permalink(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:price, :duration, :street,:lga,:state, :title, :purpose, :use_of_property, :type_of_property, :bedrooms, :bathrooms, :toliets, :description, :video_link )
    end

end
