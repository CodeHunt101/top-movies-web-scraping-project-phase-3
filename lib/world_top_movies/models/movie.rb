class WorldTopMovies::DB::Movie < ActiveRecord::Base
  has_many :user_movies
  has_many :users, through: :user_movies

  def self.add_movies(user, movie_urls)
    # Finds or creates new Favourite movie instances and adds them to the given user
    movie_urls.each do |movie_url|
      if user.movies.none?{|m| m.url == movie_url}
        fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
        user.movies << self.find_or_create_by(title: fav_movie.title, url: fav_movie.url)
      end
    end
  end

  def self.add_movie(user, movie_url)
    fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
    user.movies << self.find_or_create_by(title: fav_movie.title, url: fav_movie.url)
  end
end