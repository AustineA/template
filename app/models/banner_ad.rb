class BannerAd < ApplicationRecord
	has_one_attached :sidebar_image
  has_one_attached :home_image
  has_one_attached :home_mobile_image
  has_one_attached :listing_image
  has_one_attached :listing_mobile_image
  belongs_to :user
  after_create :generate_reference

  def self.banner_ad
		{   
      strip: true,
      'sampling-factor': '4:2:0',
      quality: '45',
      interlace: 'JPEG',
      colorspace: 'sRGB'
    }
	end

  def generate_reference
  	self.update_attributes(ref_no: "BA-#{rand(36**16).to_s(26).upcase}", expiring_date: Time.now)
	end
end
