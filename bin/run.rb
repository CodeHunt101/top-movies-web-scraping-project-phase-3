#!/usr/bin/env ruby
require_relative '../lib/world_top_movies.rb'

app = WorldTopMovies::CLI.new
app.run

WorldTopMovies::Scraper.new("Sport").make_movies
# WorldTopMovies::Movie.all[44].details
# WorldTopMovies::Movie.all.each do |m|
#   puts m.title
#   puts m.countries_of_origin
#   puts m.official_site
#   puts m.languages
#   puts ""
# end

# WorldTopMovies::Movie.all[13].countries_of_origin

# WorldTopMovies::Movie.all.each do |movie_instance|
#   # movie_instance = WorldTopMovies::Movie.find_by_url(m.url)
#   puts "\n----------------------------------------------"
#   puts "         #{movie_instance.title.upcase} - #{movie_instance.year}"
#   puts "----------------------------------------------"
#   puts "\nGenres:       #{movie_instance.genres.join(" - ") || "N/A"}"
#   puts "Duration:     #{movie_instance.duration}"
#   puts "Stars:        #{movie_instance.stars.join(" - ")}"
#   puts "Rating:       #{movie_instance.user_rating} from #{movie_instance.votes} votes"
#   puts "Metascore:    #{movie_instance.metascore || "N/A"}"
#   puts "Directed by:  #{movie_instance.director}"
#   puts "Total Awards: #{movie_instance.get_awards_count || "N/A"}"
#   puts "\n-----------------Description-------------------"
#   puts "\n#{movie_instance.description || "N/A"}\n"
#   puts "\nStoryline:\n#{movie_instance.storyline || "N/A"}\n"
#   puts "\n----------------Other Details------------------\n"
#   puts "Countries:    #{movie_instance.countries_of_origin || "N/A"}"
#   puts "Languages:    #{movie_instance.languages || "N/A"}"
#   puts "Website:      #{movie_instance.official_site || "N/A"}"
#   puts "\nThis movie has a gross revenue of #{movie_instance.gross_revenue}"
# end