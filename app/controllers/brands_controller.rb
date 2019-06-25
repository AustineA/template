class BrandsController < ApplicationController
  before_action :brand_params, only: [:show, :edit, :update, :destroy]
  
    def index
      if current_user.admin
       return  @brands = Brand.paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      else
        return @brands = current_user.brands.paginate(:page => params[:page], :per_page => 8).order(created_at: :desc)
      end

      render :index
    end
  
    def show
    end
  
    def create
      @brand= current_user.brands.build(brand_params)
  
      if @brand.save
        render :show, status: :created
      else
        render json: @brand.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @brand.update(brand_params)
          render :show
        else
          render json: @brand.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @brand.destroy
    end
  
    private
    def set_brand
      @brand = Brand.find_by_ref_no(params[:id])
    end
  
    def brand_params
      params.require(:brand).permit(:url, :amount, :logo, :duration )
    end
end
