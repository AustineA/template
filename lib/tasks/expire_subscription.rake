task :expire_subscription => :environment do
  Subscription.expired.each do |subs|
    puts "Expirings - #{subs.user.f_name}'s #{subs.plan} subscription"
    subs.update_attributes( plan: "FREE", expiring_date: '', boost: 0, priorities: 0 )
  end
end