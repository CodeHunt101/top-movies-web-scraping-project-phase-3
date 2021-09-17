# CONFIRM: require bundler two ways
require 'bundler'
Bundler.require
require_all 'lib'

# From labs (TODO: check the difference) Confirm!!!
# ENV['SINATRA_ENV'] ||= 'development'
# ActiveRecord::Base.establish_connection(ENV['SINATRA_ENV'].to_sym)

# Establish connection with the database through database.yml (confirm!!!)
ActiveRecord::Base.establish_connection(:development)

# Avoid undesired outputs on the terminal
ActiveRecord::Base.logger = nil
