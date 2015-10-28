ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'shoulda/matchers'
require 'spec_helper'
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  include Rack::Test::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end

  config.before(:each, type: :feature) do
    allow_any_instance_of(SlackService).to receive(:post_message)
  end

  def app
    Rails.application
  end
end
