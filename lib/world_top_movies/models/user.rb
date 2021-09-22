class WorldTopMovies::DB::User < ActiveRecord::Base
  has_many :user_movies, dependent: :destroy
  has_many :movies, through: :user_movies
  has_many :user_notes, dependent: :destroy
  has_many :notes, through: :user_notes

  def print_all_favourite_movie_titles
    if !self.movies.empty? 
      puts("\nOk! Your favourite movies are:\n\n")
      sleep(1.5)
      self.movies.sort_by{|m| m.title}.each_with_index do |m,i| 
        sleep(0.01)
        WorldTopMovies::Movie.print_movie_compact(m, i)
      end
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