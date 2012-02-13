source 'https://rubygems.org'

gem 'rails', '3.2.0'
gem 'heroku'
gem 'jquery-rails'
gem 'devise'
gem 'simple-rss'

# Backbone helper (mostly used for js libs)
gem 'rails-backbone'

# Faster web server (run -> rails server thin start)
gem 'thin'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'rspec-rails', '2.8.1'
  gem 'faker', '1.0.1'
  gem 'jasminerice'
  
  # Guard setup
  # Install chrome ext: https:/chrome.google.com/extensions/detail/jnihajbhpnppcggbcgedagnkighmdlei
  # bundle exec guard
  gem 'guard'

  # Guard inits
  gem 'guard-livereload'
  gem 'guard-rspec'
   
  # windows ftw
  gem 'win32console'
end

group :test do
  gem 'sqlite3'
  gem 'rspec', '2.8.0'
  gem 'factory_girl_rails', '1.6.0'
end

group :production do
  gem 'pg'
end
