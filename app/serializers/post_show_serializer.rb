class PostShowSerializer
  include FastJsonapi::ObjectSerializer
  attributes :price, :duration, :street,:lga,:state, :title, :purpose, :use_of_property, :sub_type_of_property, :bedrooms, :bathrooms, :toliets, :description, :video_link

  attributes 
end
