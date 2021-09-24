class WorldTopMovies::DB::Movie < ActiveRecord::Base
  has_many :user_movies
  has_many :users, through: :user_movies
  has_many :notes

  def self.generate_attributes_from_url(movie_url)
    fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
    attributes = {
      title: fav_movie.title,
      year: fav_movie.year,
      duration: fav_movie.duration,
      genres: fav_movie.genres.join(" - "),
      user_rating: fav_movie.user_rating,
      metascore: fav_movie.metascore,
      description: fav_movie.description,
      director: fav_movie.director,
      stars: fav_movie.stars.join(" - "),
      votes: fav_movie.votes,
      gross_revenue: fav_movie.gross_revenue,
      url: fav_movie.url,
    }
  end

  def self.add_movies(user:, movie_urls:)
    # Finds or creates new Favourite movie instances and adds them to the given user
    movie_urls.class != Array && movie_urls = movie_urls.split()
    movie_urls.each do |movie_url|
      if user.movies.none? { |m| m.url == movie_url }
        attributes = self.generate_attributes_from_url(movie_url)
        user.movies << self.find_or_create_by(attributes)
      end
    end
  end

  def print_movie_details
    attributes = {
      title: self.title,
      year: self.year,
      duration: self.duration,
      genres: self.genres,
      user_rating: self.user_rating,
      metascore: self.metascore.to_s,
      description: self.description,
      director: self.director,
      stars: self.stars,
      votes: self.votes,
      gross_revenue: self.gross_revenue,
      url: self.url,
      database: true,
    }
    movie = WorldTopMovies::Movie.new(attributes)
    movie.scrape_and_print_movie
    print_movie_notes
  end

  def print_movie_notes
    logged_user = WorldTopMovies::CLI.user
    notes = self.notes.select { |n| n.user && n.user.username == logged_user.username }
    puts "\n----------------#{"My Own notes".bold}------------------"
    notes.empty? ? puts("No notes left") : notes.each { |n| puts "\n-#{n.note_message}- on #{n.created_at.localtime}" }
    puts "----------------------------------------------"
  end
end
