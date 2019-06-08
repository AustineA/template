class PostRequest < ApplicationRecord
  belongs_to :user
  searchkick
end
