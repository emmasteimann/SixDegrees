source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'neo4j'
gem 'nokogiri',             '~> 1.5.5'
gem 'json'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "neo4jrb-paperclip", :require => "neo4jrb_paperclip"
# gem "aws-s3",            :require => "aws/s3"

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
end
group :production do
  gem 'closure-compiler'
end
platforms :jruby do
  gem 'jruby-openssl'
  gem 'therubyrhino'
  gem 'jruby-rack',                     '= 1.1.1'
  gem 'trinidad',                       '= 1.2.3'
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes

  gem 'uglifier', '>= 1.0.3', :group => [:test, :development]
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
