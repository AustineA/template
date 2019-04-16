class Post < ApplicationRecord
	before_create :generate_permalink
	has_many_attached :images
	belongs_to :user
	searchkick
	WATERMARK_PATH = Rails.root.join('lib', 'assets', 'images', '2dots-watermark.png')


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
      quality: '85',
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
end
