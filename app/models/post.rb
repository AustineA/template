class Post < ApplicationRecord
	before_create :generate_permalink
	after_create :generate_reference, :assign_tags, :assign_promotion_updated_at
	has_many_attached :images
	has_many :markers, dependent: :destroy
	belongs_to :user, :counter_cache => true
	searchkick
	WATERMARK_PATH = Rails.root.join('lib', 'assets', 'images', '2dots-watermark.png')

	scope :scorable, -> { where("score > ?", 0) }

	def self.thumbnail_options
		{ 
      resize: "300x300^", 
      gravity: 'center', 
      extent: '300x300',   
      strip: true,
      'sampling-factor': '4:2:0',
      quality: '85',
      interlace: 'JPEG',
      colorspace: 'sRGB'
    }
	end

	def self.large_options
		{
			resize: "850x500^", 
			gravity: 'center',
			draw: 'image SrcOver 0,0 0.5,0.5 "' + Post::WATERMARK_PATH.to_s + '"',
			strip: true,
      'sampling-factor': '4:2:0',
      quality: '85',
      interlace: 'JPEG',
      colorspace: 'sRGB'
		}
	end
	
	def self.medium_options
		{
			resize: "320x240^", 
			gravity: 'center',
			strip: true,
      'sampling-factor': '4:2:0',
      quality: '35',
      interlace: 'JPEG',
			colorspace: 'sRGB'
		}
	end

	def card_image i
		return self.images[i].variant(combine_options: Post.medium_options).processed
	end

  def to_param
		permalink
	end

	private

	def generate_permalink
		pattern=self.title.parameterize+"-in-#{self.lga.parameterize}-#{self.state.parameterize}"
		duplicates = Post.where('permalink like ?', "%#{pattern}%")

		if duplicates.present?
			self.permalink = "#{pattern}-#{duplicates.count+1}"
		else
			self.permalink = pattern
		end

	end


	def generate_reference
  	self.update_attributes(reference_id: "#{rand(5**12).to_s(28).upcase}")
	end

	def assign_tags
		self.update_attributes(tags: "#{self.state}, #{self.lga}, #{self.area}")
	end

	def assign_promotion_updated_at
		self.update_attributes(promotion_updated_at: Time.now.beginning_of_year)
	end

	
end

		