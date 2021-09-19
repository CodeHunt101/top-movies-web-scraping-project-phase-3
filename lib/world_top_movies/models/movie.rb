class WorldTopMovies::DB::Movie < ActiveRecord::Base
  has_many :user_movies
  has_many :users, through: :user_movies

  def self.add_movies(user, movie_urls)
    # Finds or creates new Favourite movie instances and adds them to the given user
    movie_urls.each do |movie_url|
      if user.movies.none?{|m| m.url == movie_url}
        fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
        attributes = {
          title: fav_movie.title,
          year: fav_movie.year,
          duration: fav_movie.duration,
          genres: fav_movie.genres,
          user_rating: fav_movie.user_rating,
          metascore: fav_movie.metascore,
          description: fav_movie.description,
          director: fav_movie.director,
          stars: fav_movie.stars,
          votes: fav_movie.votes,
          gross_revenue: fav_movie.gross_revenue,
          url: fav_movie.url,
        }
        user.movies << self.find_or_create_by(attributes)
        # user.movies << self.find_or_create_by(title: fav_movie.title,  url: fav_movie.url)
      end
    end
  end

  def self.add_movie(user, movie_url)
    fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
    attributes = {
      title: fav_movie.title,
      year: fav_movie.year,
      duration: fav_movie.duration,
      genres: fav_movie.genres,
      user_rating: fav_movie.user_rating,
      metascore: fav_movie.metascore,
      description: fav_movie.description,
      director: fav_movie.director,
      stars: fav_movie.stars,
      votes: fav_movie.votes,
      gross_revenue: fav_movie.gross_revenue,
      url: fav_movie.url,
    }
    user.movies << self.find_or_create_by(attributes)
    # user.movies << self.find_or_create_by(title: fav_movie.title, url: fav_movie.url)
  end
end