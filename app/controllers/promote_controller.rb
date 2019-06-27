class PromoteController < ApplicationController
  before_action :authenticate_user


  def promoter
    max_boost = 4
    max_priority = 1
    post = Post.find_by_permalink(params[:id])
    subscription = current_user.subscription
    boost = params[:promote][:boost] if params[:promote][:boost].present?
    priority = params[:promote][:priority] if params[:promote][:priority].present?
    current_boost = post.boost
    current_priority = post.priority
    remaining_boost = subscription.boost
    remaining_priorities = subscription.priorities
    score = post.score
    message = { priority: "", boost: "" }
    
    if ( priority && ( priority <= max_priority ) && (remaining_priorities >= priority) && ( current_priority + priority  <= max_priority ) )
      new_priority = current_priority + priority
      post.update_attributes(priority: new_priority, score: score + priority)
      subscription.update_attributes(priorities: remaining_priorities - priority)
      priority_count = current_user.posts.where("priority > ?", 0).count
      current_user.update_attributes(priority_count: priority_count)
      message[:priority] = "success"
    end

    
    updated_post = Post.find_by_permalink(params[:id])


    if ( boost && ( boost <= max_boost ) && (remaining_boost >= boost) && ( current_boost + boost  <= max_boost ) && updated_post.priority > 0)
      new_boost = current_boost + boost
      updated_score = updated_post.score
      updated_post.update_attributes(boost: new_boost, score: updated_score + boost)
      subscription.update_attributes(boost: remaining_boost - boost)
      boost_count = current_user.posts.where("boost > ?", 0).count
      current_user.update_attributes(boost_count: boost_count)
      message[:boost] = "success"
    end

    render json: message
  end
end
