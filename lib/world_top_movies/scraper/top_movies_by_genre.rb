class TopMoviesByGenre < WorldTopMovies::Scraper
  
  @@genres = [
    "action",
    "adventure",
    "animation",
    "biography",
    "comedy",
    "crime",
    "drama",
    "family",
    "fantasy",
    "history",
    "horror",
    "mystery",
    "romance",
    "scr-fi",
    "sport",
    "thriller",
    "war"
  ]

  # def generateGenresArr
  #   xml = self.get_top_movies_general_page.css("li.subnav_item_main a")
  #   xml.each {|genre| @@genres << genre.text.strip}
  # end

  def get_movies(genre = nil)
    self.get_top_movies_by_genre_page(genre).css("div.lister-item.mode-advanced")
  end

  def make_movies(genre = nil)
    self.get_movies(genre).each do |m|
      movie = WorldTopMovies::Movie.new
      movie.title = 
    end
  end

end

movies = TopMoviesByGenre.new
# movies.generateGenresArr
movies.make_movies('action')

