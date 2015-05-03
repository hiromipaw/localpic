# WARNING: the namespace is also set in unicorn.rb
require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
end

Sidekiq.configure_server do |config|
  config.redis = {
                  url: ENV['REDISCLOUD_URL'],
                  namespace: 'sidekiq-clipper'
                 }
end

Sidekiq.configure_client do |config|
  config.redis = {
                  url: ENV['REDISCLOUD_URL'],
                  namespace: 'sidekiq-clipper'
                 }
end
