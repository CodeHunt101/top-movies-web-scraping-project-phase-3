class TopMoviesByGenre < WorldTopMovies::Scraper
  @@genres = []

  def generateGenresArr
    xml = self.get_top_movies_page.css("li.subnav_item_main a")
    xml.each {|genre| @@genres << genre.text.strip}
    # binding.pry
  end

end

# TopMoviesByGenre.new.generateGenresArr