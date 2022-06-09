# frozen_string_literal: true

source 'https://rubygems.org'
gemspec name: 'classifier-reborn'

# For testing with GSL support & bundle exec
gem 'gsl' if ENV['LINALG_GEM'] == 'gsl'

if ENV['LINALG_GEM'] == 'numo'
  gem 'numo-narray'
  gem 'numo-linalg'
end
