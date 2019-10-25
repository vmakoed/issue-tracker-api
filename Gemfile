# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.0'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'bcrypt', '~> 3.1.7'
gem 'enumerate_it', '~> 3.0'
gem 'fast_jsonapi', '~> 1.5'
gem 'jwt', '~> 2.2', '>= 2.2.1'
gem 'pagy', '~> 3.6'
gem 'pundit', '~> 2.1'
gem 'subroutine', '~> 0.8.1'

group :development, :test do
  gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'pry', '~> 0.12.2'
  gem 'rspec-rails', '~> 3.9'
  gem 'rubocop', '~> 0.75.1', require: false
  gem 'rubocop-rspec', '~> 1.36', require: false
end

group :development do
  gem 'brakeman', '~> 4.7'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 4.1', '>= 4.1.2'
end
