json.array! @agents do |agent|
  json.company agent.company
  json.permalink agent.username
  if agent.avatar.attached?
    json.avatar url_for(agent.avatar.variant(combine_options: User.avatar))
  end
end