class User < ApplicationRecord
	has_secure_password
	has_many :posts

	validates :username, presence: true, :uniqueness => true
	validates :email, presence: true, :uniqueness => true



  def self.from_token_request request
		username = request.params["auth"] && request.params["auth"]["username"]
    email = request.params["auth"] &&  request.params["auth"]["email"]
		self.find_by username: username or self.find_by email: email
	end
end
