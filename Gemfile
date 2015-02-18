source "http://rubygems.org"

ruby "2.2.0"

gem "rails", "4.2.0"

gem "active_model_serializers"
gem "factory_girl_rails"
gem "faker"
gem "grape"
gem "grape-active_model_serializers", github: "jrhe/grape-active_model_serializers"
gem "grape-swagger-rails"
gem "pg"
gem "puma"
gem "rack-cors", require: "rack/cors"
gem "rack-timeout"
gem "uglifier"

group :development do
  gem "meta_request"
  gem "quiet_assets"
end

group :development, :test do
  gem "awesome_print"
  gem "byebug"
  gem "database_cleaner"
  gem "poltergeist"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry-theme"
  gem "rspec-rails"
  gem "rspec-collection_matchers"
  gem "rubocop"
  gem "shoulda-matchers"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console", "~> 2.0"
end

group :production do
  gem "rails_12factor"
end
