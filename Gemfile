source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'
gem 'rails', '~> 5.2.1'
# gem 'activestorage'

gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sidekiq'
gem "sidekiq-cron", "~> 0.6.3"
gem 'activerecord-import', '~> 0.22.0'
gem 'apipie-rails'
gem 'sass-rails', '~> 5.0'
gem 'devise'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://gith  ub.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'bootsnap', '>= 1.1.0', require: false
gem "bootstrap_form", ">= 4.0.0.alpha1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
  gem 'overcommit'
  gem 'awesome_print', '1.8.0'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'faker', '1.8.4'
  gem 'mocha'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'shoulda-matchers', '~> 3.1.1'
  gem 'pry-rails'
  gem 'simplecov', '0.15.1', require: false
  gem 'rspec_junit_formatter'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]