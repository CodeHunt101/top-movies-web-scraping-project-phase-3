class WorldTopMovies::User < ActiveRecord::Base
  has_many :user_movies
  has_many :favourite_movies, through: :user_movies

  # def favourite_movie_titles
  #   self.favourite_movies.map{|m| m.title}
  # end

  def print_all_favourite_movie_titles
    self.favourite_movies.empty? && puts("Oops, you haven't favourited any movies yet!!")
    self.favourite_movies.each {|m| puts m.title}
  end

  def favourite_movie_titles
    # returns a hash with key=title, value=url of all fav movies
    result = {}
    self.favourite_movies.each do |m|
      result[m.title] = m.url
    end
    result
  end

  def find_movie_from_url(movie_url)
    self.favourite_movies.find{|m|m.url == movie_url}
  end

end