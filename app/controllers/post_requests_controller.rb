class PostRequestsController < ApplicationController
  before_action :set_post_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:show, :index]

  
    def index
      @post_requests = PostRequest.all.order(created_at: :desc)
    end
  
    def show
    end
  
    def create
      @post_request = current_user.post_requests.build(post_request_params)
  
      if @post_request.save
        render :show, status: :created
      else
        render json: @post_request.errors.full_messages.to_sentence, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @post_request.update(post_request_params)
          render :show
        else
          render json: @post_request.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @post_request.destroy
    end
  
    private
    def set_post_request
      @post_request = PostRequest.find(params[:id])
    end
  
    def post_request_params
      params.require(:post_request).permit(:purpose, :budget, :type_of_property, :state, :lga, :area, :description, )
    end
end
