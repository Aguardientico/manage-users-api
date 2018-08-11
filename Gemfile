source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'jwt'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.1'
gem 'will_paginate'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
end
