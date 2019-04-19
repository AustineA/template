class User < ApplicationRecord
	has_secure_password
	has_many :posts, dependent: :destroy
	has_one_attached :avatar
	searchkick
	validates :username, presence: true, :uniqueness => true
	validates :email, presence: true, :uniqueness => true

	# scope :sale, -> { where(purpose: "SALE") }
	# scope :rent, -> { where(purpose: "RENT") }
	# scope :short, -> { where(purpose: "SHORT") }
	# scope :development, -> { where(purpose: "NEW") }
	# scope :installment, -> { where(purpose: "INSTALLMENT") }



  def self.from_token_request request
		username = request.params["auth"] && request.params["auth"]["username"]
    email = request.params["auth"] &&  request.params["auth"]["email"]
		self.find_by username: username or self.find_by email: email
	end

	def self.avatar
		{
			resize: "500x500", 
			gravity: 'center',
			strip: true,
      'sampling-factor': '4:2:0',
      quality: '85',
      interlace: 'JPEG',
			colorspace: 'sRGB'
		}
	end

	def to_token_payload
    {
      sub: id,
      email: email,
      username: username,
      admin: admin
    }
  end



end
