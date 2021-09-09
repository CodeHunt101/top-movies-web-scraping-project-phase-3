class TopMoviesGeneral < WorldTopMovies::Scraper
    
  def get_movies
    self.get_top_movies_general_page.css("tr").slice(1..-1)
  end

  def make_movies
    self.get_movies.each do |m|
      movie = WorldTopMovies::Movie.new
      movie.title = m.css(".titleColumn a").text
      movie.year = m.css("span.secondaryInfo").text[1...-1]
      movie.imdb_rating = m.css(".imdbRating strong").text.to_f
      movie.link = "https://imdb.com" + m.css(".titleColumn a").attribute("href").value
        # Slow
        # movie.director = Nokogiri::HTML(open(movie.link)).css("a.ipc-metadata-list-item__list-content-item--link")[0].text
    end 
    # binding.pry
  end

end

# TopMoviesGeneral.new.make_movies