json.name "#{@user.f_name}  #{@user.l_name}"
json.(@user, :phone, :email, :account_type)
json.location "#{@user.address['street']}, #{@user.address['city']}, #{@user.address['state']}. Nigeria" if @user.address

if @agents_only
  json.company @user.company
  json.about @user.about
end

if @user.avatar.attached?
  json.avatar url_for(@user.avatar.variant(combine_options: User.avatar))
end

