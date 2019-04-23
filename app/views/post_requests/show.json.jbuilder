json.title "Looking for #{@post_request.type_of_property} to #{@post_request.purpose}"
json.location "In #{@post_request.area if @post_request.area}, #{@post_request.lga}, #{@post_request.state} "
json.(@post_request,:budget, :description)

json.buyer do
  json.name @post_request.user.f_name
  json.phone @post_request.user.phone
  if @post_request.user.avatar.attached?
    json.avatar url_for(@post_request.user.avatar.variant(combine_options: User.avatar))
  end
end