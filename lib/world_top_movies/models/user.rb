class WorldTopMovies::DB::User < ActiveRecord::Base
  has_many :user_movies, dependent: :destroy
  has_many :movies, through: :user_movies

  def print_all_favourite_movie_titles
    if self.movies.empty? 
      puts("Oops, you haven't favourited any movies yet!!")
    else
      puts("\nOk! Your favourite movies are:\n\n")
      self.movies.sort_by{|m| m.title}.each_with_index{|m,i| WorldTopMovies::Movie.print_movie_compact(m, i)} 
    end
  end

  def favourite_movie_titles
    # returns a hash with key=title, value=url of all fav movies
    result = {}
    self.movies.sort_by{|m| m.title}.each{|m| result[m.title] = m.url}
    result
  end

  def find_movie_from_url(movie_url)
    self.movies.find{|m|m.url == movie_url}
  end

end