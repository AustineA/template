task :clear_promotion => :environment do
  Post.where("boost > ? or priority > ?", 0, 0 ).each do |post|
    if post.user.subscription && post.user.subscription.expiring_date == nil
      puts "Clearing - #{post.user.f_name}'s priority and boosted listings with post_id: #{post.id}"
      post.update_attributes( boost: 0, priority: 0, promotion_updated_at: Time.now.beginning_of_year, score: 0 )
    end
  end
end