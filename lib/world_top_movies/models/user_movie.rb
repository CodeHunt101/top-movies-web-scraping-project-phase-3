class WorldTopMovies::UserMovie < ActiveRecord::Base
  belongs_to :favourite_movie
  belongs_to :user
end