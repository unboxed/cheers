source "https://rubygems.org"

ruby "2.2.2"

gem "pg"

gem "dotenv-rails", require: "dotenv/rails-now"

gem "acts-as-taggable-on", "~> 3.4"
gem "config"
gem "gemoji"
gem "rails", "4.2.2"
gem "slack-api"

group :production do
  gem "rails_12factor"
end

gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "jquery-rails"

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "factory_girl_rails"
end

group :development, :test do
  gem "launchy"
  gem "rspec-rails", "~> 3.2.0"
  gem "shoulda-matchers"
  gem "pry"
  gem "web-console", "~> 2.0"
end
