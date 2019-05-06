json.(@user,:company, :phone, :email, :about)
json.location "#{@user.address['street']}, #{@user.address['city']}, #{@user.address['state']}. Nigeria" if @user.address
if @user.avatar.attached?
  json.avatar url_for(@user.avatar.variant(combine_options: User.avatar))
end