json.array! @agents do |agent|
  json.company agent.company
  if agent.avatar.attached?
    json.avatar url_for(agent.avatar.variant(combine_options: User.avatar))
  end
end