source 'https://rubygems.org'

ruby "2.2.2"

gem 'rails', '4.2.2'
gem 'acts-as-taggable-on', '~> 3.4'

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "factory_girl_rails"
end

group :development, :test do
  gem "launchy"
  gem "rspec-rails", "~> 3.2.0"
  gem "shoulda-matchers"
  gem 'pry'
  gem 'sqlite3'
  gem 'web-console', '~> 2.0'
end
