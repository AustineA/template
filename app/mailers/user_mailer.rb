class UserMailer < ApplicationMailer
  def iforgot(user, temp_password)
    @user = user
    @temp_password = temp_password
    mail(to: @user.email, subject: '2dots Properties - Password Reset')
  end
end
