require 'pry'
require 'nokogiri'
require 'open-uri'
require 'HTTParty'
require 'colorize'
require 'artii'
require "tty-prompt"
require "sinatra/activerecord"

# require_relative '../lib/world_top_movies/cli'
# require_relative '../lib/world_top_movies/scraper'
# require_relative '../lib/world_top_movies/movie'
# require_relative '../lib/world_top_movies/user'
# require_relative '../lib/world_top_movies/user_movie'


# JOKES
require 'bundler'
Bundler.require

# From labs
# ENV['SINATRA_ENV'] ||= 'development'
# ActiveRecord::Base.establish_connection(ENV['SINATRA_ENV'].to_sym)

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil
require_all 'lib'