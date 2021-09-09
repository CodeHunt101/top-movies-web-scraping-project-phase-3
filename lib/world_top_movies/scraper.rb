class WorldTopMovies::Scraper
  
  def get_top_movies_page
    html = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
    Nokogiri::HTML(open(html))
  end



  # class TopMoviesByGenre
  #   @@genres = []

  #   def getGenres

  #   end

  # end
  

end



# WorldTopMovies::Scraper::MovieInfoPage.new.get_movie_info_pages