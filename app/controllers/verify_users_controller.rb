class VerifyUsersController < ApplicationController
  before_action :set_verify_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user
  
    def index
      if params[:q].present?
      @result = VerifyUser.ransack(user_email_start: params[:q]).result(distinct: true)
      @verify_users = @result.paginate(:page => params[:page], :per_page => 8).order(:company)
      else
        @verify_users = VerifyUser.paginate(:page => params[:page], :per_page => 8).order("RANDOM()")
      end
      render :index
    end
  
    def show
    end
  
    def create
      @verify_user= current_user.verify_users.build(verify_user_params)
  
      if @verify_user.save
        render :show, status: :created
      else
        render json: @verify_user.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @verify_user.update(verify_user_params)
          render :show
        else
          render json: @verify_user.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @verify_user.destroy
    end
  
    private
    def set_verify_user
      @verify_user = VerifyUser.find(params[:id])
    end
  
    def verify_user_params
      params.require(:verify_user).permit(:cac, :id_card, :bill)
    end
end
