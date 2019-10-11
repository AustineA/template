SitemapGenerator::Sitemap.default_host = "https://2dotsproperties.com" # Your Domain Name
SitemapGenerator::Sitemap.public_path = 'tmp/sitemap'
# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new( 
aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
fog_provider: 'AWS',
fog_directory: '2dots',
fog_region: 'eu-west-2'
)

# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://2dots.s3.amazonaws.com"

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
