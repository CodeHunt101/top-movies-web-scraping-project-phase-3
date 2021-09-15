require_relative './lib/world_top_movies'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :c do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end