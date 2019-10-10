# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://2dotsproperties.com"

SitemapGenerator::Sitemap.create do
  # Add all posts:
    Post.find_each do |post|
      add "/#{post.permalink}", :lastmod => post.updated_at
    end

  # Add all forum post:
    Forum.find_each do |forum|
      add "/forum/#{forum.permalink}", :lastmod => forum.updated_at
    end
  # Add all forum agents:
    User.find_each do |user|
      add "/agents/#{user.username}", :lastmod => user.updated_at
    end
end
