source "http://rubygems.org"

# TODO: Check if this exact is required or if we could upgrade to
# Rails 2.3.HEAD or even Rails 3.
gem "rails", '2.3.5'

gem 'paperclip', '>= 2.3.1.1' # This still requires ActiveSupport = 2.3.5
gem 'will_paginate', '~> 2.3.11'
gem 'thinking-sphinx', '1.3.18'
gem 'ruby-openid', '2.0.4'
gem 'RedCloth', '~> 4.2.2' # TODO: just used the lastest stable here

## Database Adapter.
# Select the one you actually use

# By default, Rails has selected sqlite3.
gem "sqlite3-ruby", :require => "sqlite3"
# gem "pg"
# gem "mysql2"
# gem "sqlite3-ruby", :require_as => "sqlite3"

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :test do
  # bundler requires these gems while running tests
  gem "rspec"
  gem "rspec-rails", ">= 1.2.9"
  gem 'dataset' # TODO: set version
  gem 'lindo' #TODO: set version
  gem 'ruby-debug'
end
