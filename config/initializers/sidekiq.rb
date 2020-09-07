# frozen_string_literal: true

url = ENV.fetch('REDISTOGO_URL', 'redis://127.0.0.1:6379')

Sidekiq.configure_server do |config|
  config.redis = { url: url }
  config.redis = { :size => 12 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: url }
  config.redis = { :size => 1 }
end
