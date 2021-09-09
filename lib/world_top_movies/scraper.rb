class WorldTopMovies::Scraper
  
  def get_top_movies_general_page
    html = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
    Nokogiri::HTML(open(html))
  end

  def get_top_movies_by_genre_page(genre)
    html = "https://www.imdb.com/search/title/?title_type=feature&num_votes=200000,&genres=#{genre}&sort=user_rating,desc&view=advanced"
    Nokogiri::HTML(open(html))
  end

end



# WorldTopMovies::Scraper::MovieInfoPage.new.get_movie_info_pages

# Improvement
# https://www.imdb.com/search/title/?title_type=feature&num_votes=982000,&genres=&sort=user_rating,desc&view=advanced