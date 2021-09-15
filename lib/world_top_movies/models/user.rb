class WorldTopMovies::User < ActiveRecord::Base
  has_many :user_movies
  has_many :favourite_movies, through: :user_movies
end