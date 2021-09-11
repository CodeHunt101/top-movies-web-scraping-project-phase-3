#!/usr/bin/env ruby
require_relative '../lib/world_top_movies.rb'

app = WorldTopMovies::CLI.new
app.run

# WorldTopMovies::Scraper.new('horror').make_movies
# # WorldTopMovies::Movie.all[44].details
# WorldTopMovies::Movie.all[12].details