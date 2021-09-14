class WorldTopMovies::Scraper
  
  @@genres = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
    "Comedy",
    "Crime",
    "Drama",
    "Family",
    "Fantasy",
    "History",
    "Horror",
    "Mystery",
    "Romance",
    "Sci-Fi",
    "Sport",
    "Thriller",
    "War"
  ]

  def self.genres
    @@genres
  end

  def self.get_top_movies_page(genre)
    response = HTTParty.get("https://www.imdb.com/search/title/?title_type=feature&num_votes=200000,&genres=#{genre}&sort=user_rating,desc&view=advanced")
    Nokogiri::HTML(response.body)
  end

  def self.get_movies(genre)
    self.get_top_movies_page(genre).css("div.lister-item.mode-advanced")
  end

  def self.make_movies(genre = nil)
    self.get_movies(genre).each do |m|
      movie = WorldTopMovies::Movie.new_from_page(m)
      # Fixed error from website? Include genre to the genre property if for some reson it's not there
      genre && !movie.genres.include?(genre.downcase.capitalize) && movie.genres << genre.downcase.capitalize
    end
  end

  def self.get_movie_details_page(movie_url)
    response = HTTParty.get(movie_url)
    Nokogiri::HTML(response.body)
  end

end