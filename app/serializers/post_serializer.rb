class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes  :title, :price, :street, :lga, :state
  attribute :url do |i|
    "/#{i.permalink}"
  end
end
