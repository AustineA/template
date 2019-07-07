class Marker < ApplicationRecord
	belongs_to :user
  belongs_to :post
  
  scope :bookmarks, -> { where(type_of_maker: "BOOKMARK") }
	scope :reported, -> { where(type_of_maker: "REPORTED") }
  

end
