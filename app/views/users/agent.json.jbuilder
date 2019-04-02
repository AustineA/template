json.user do
  json.(@user,:company, :phone, :email, :about)
  json.location "#{@user.address['street']}, #{@user.address['city']}, #{@user.address['state']}. Nigeria"
  if @user.avatar.attached?
    json.avatar url_for(@user.avatar.variant(combine_options: User.avatar))
  end

  json.posts @user.posts do |post|
    json.location "#{post.lga}, #{post.state}"
    json.title post.title
    json.price post.price
    json.purpose post.purpose

    (0..0).each do |image|
      json.card_thumbnail url_for post.card_image image
    end
  end
end