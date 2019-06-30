class BannerAdsController < ApplicationController
  before_action :set_banner_ad, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  
    def index
      if current_user.admin
       return  @banner_ads = BannerAd.paginate(:page => params[:page], :per_page => 2).order(created_at: :desc)
      else
        return @banner_ads = current_user.banner_ads.paginate(:page => params[:page], :per_page => 2).order(created_at: :desc)
      end

      render :index
    end
  
    def show
    end
  
    def create
      @banner_ad= current_user.banner_ads.build(banner_ad_params)
  
      if @banner_ad.save
        render :show, status: :created
      else
        render json: @banner_ad.errors, status: :unprocessable_entity
      end
    end
  
  
    def update
        if @banner_ad.update(banner_ad_params)
          render :show
        else
          render json: @banner_ad.errors, status: :unprocessable_entity
        end
    end
  
  
    def destroy
      @banner_ad.destroy
    end
  
    private
    def set_banner_ad
      @banner_ad = BannerAd.find_by_ref_no(params[:id])
    end
  
    def banner_ad_params
      params.require(:banner_ad).permit(:amount, :url, :banner_type, :duration, :sidebar_image, :home_image, :home_mobile_image, :listing_image, :listing_mobile_image)
    end
end
