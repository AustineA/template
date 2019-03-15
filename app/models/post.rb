class Post < ApplicationRecord
	before_create :generate_permalink
	has_many_attached :images
	belongs_to :user



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
