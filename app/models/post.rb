require 'uploads'


class Post < ApplicationRecord
	before_create :generate_permalink
	has_many_attached :images
	belongs_to :user

	WATERMARK_PATH = Rails.root.join('lib', 'assets', 'images', '2dots-watermark.png')

	def optimized variant
		self.images.each do |image|
			variation = ActiveStorage::Variation.new(Uploads.resize_to_fill_watermarked(width: 500, height: 500, blob: image.blob))
			ActiveStorage::Variant.new(image.blob, variation)
		end
  end

	def filled
			self.images.each do |image|
				variation = ActiveStorage::Variation.new(Uploads.resize_to_fill(width: 500, height: 500, blob: image.blob))
				ActiveStorage::Variant.new(image.blob, variation)
			end
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
