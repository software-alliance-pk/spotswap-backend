source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.6'
gem 'acts_as_paranoid'
gem 'activestorage'
gem 'pg', '~> 1.4', '>= 1.4.3'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

gem 'geokit-rails'
gem 'pg_search'
gem 'will_paginate', '~> 3.3'
gem 'will_paginate-bootstrap'
gem 'trix'
gem 'devise'
gem 'actiontext', '~> 6.1.6'
gem 'jquery-rails'
gem 'cloudinary'
gem 'fcm'
gem 'countries'
gem 'rexml'
gem 'pg_trgm', '~> 0.0.1'

# Use Json Web Token (JWT) for token based authentication
gem 'jwt'
gem 'stripe'
gem 'stripe_event'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'dotenv-rails'

# Use Active Storage variant
gem "braintree", "~> 4.9.0"
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# gem 'capistrano', '~> 3.11'
# gem 'capistrano-rails', '~> 1.4'
# gem 'capistrano-passenger', '~> 0.2.0'
# gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "aws-sdk-s3", "~> 1.119"
gem 'rack-cors', require: 'rack/cors'
