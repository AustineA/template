json.array! @posts do |post|
  json.location "#{post.lga}, #{post.state}"
  json.(post,:title, :price, :permalink, :type_of_property, :purpose, :description)
  (0..0).each do |image|
    json.card_thumbnail url_for post.card_image image
  end
end