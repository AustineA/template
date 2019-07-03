class SubscriptionMailer < ApplicationMailer
  def invoice(user, subscription)
    @user = user
    @subscription = subscription
    mail(to: @user.email, subject: "your '#{@subscription.plan}' subscription was successfully updated.")
  end
end
