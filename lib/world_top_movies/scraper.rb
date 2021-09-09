class WorldTopMovies::Scraper
  
  # class MainPage
    def get_top_movies_page
      html = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
      Nokogiri::HTML(open(html))
    end
  
    def get_movies
      self.get_top_movies_page.css("tr").slice(1..6)
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
      binding.pry
    end

  # end

  # class MovieInfoPage
    
  #   def get_movie_info_pages
  #     movie_info_pages = WorldTopMovies::Movie.all.each do |m|
  #       Nokogiri::HTML(open(m.link)).css("a.ipc-metadata-list-item__list-content-item--link")[0].text
  #     end
      
  #     movie_info_pages
  #   end
  
    # def get_movies
    #   self.get_top_movies_page.css("tr").slice(1..-1)
    # end
  
    # def make_movies
    #   self.get_movies.each do |m|
    #     movie = WorldTopMovies::Movie.new
    #     movie.title = m.css(".titleColumn a").text
    #     movie.year = m.css("span.secondaryInfo").text[1...-1]
    #     movie.imdb_rating = m.css(".imdbRating strong").text.to_f
    #     movie.link = "https://imdb.com" + m.css(".titleColumn a").attribute("href").value
    #   end 
    # end

  # end

  def print_movies
    self.make_movies
    WorldTopMovies::Movie.all.each do |m|
      if m.title && m.title != ""
        puts "Title: #{m.title}"
        puts "  Year: #{m.year}"
        puts "  IMDB Rating: #{m.imdb_rating}"
        puts "  Link: #{m.link}\n\n"
      end
    end
  end
  

end


WorldTopMovies::Scraper.new.make_movies
# WorldTopMovies::Scraper::MovieInfoPage.new.get_movie_info_pages