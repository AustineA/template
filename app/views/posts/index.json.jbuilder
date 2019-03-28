json.array! @posts do |post|
  json.location "#{post.lga}, #{post.state}"
  json.(post,:title, :price, :permalink)
  (0..0).each do |image|
    json.card_thumail url_for post.card_image image
  end
end