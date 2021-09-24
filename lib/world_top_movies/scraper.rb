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
    "War",
  ]

  def self.genres
    @@genres
  end

  def self.get_top_movies_page(genre)
    #Get response from get request (raw HTML)
    response = HTTParty.get("https://www.imdb.com/search/title/?title_type=feature&num_votes=200000,&genres=#{genre}&sort=user_rating,desc&view=advanced")
    #Parse response
    Nokogiri::HTML(response.body)
  end

  def self.get_movies(genre)
    # Returns an XML object of all the movies by given genre
    self.get_top_movies_page(genre).css("div.lister-item.mode-advanced")
  end

  def self.make_movies(genre = nil)
    # Iterates over all movies from the XML object and creates new instances
    self.get_movies(genre).each do |m|
      movie = WorldTopMovies::Movie.new_from_page(m)
      # Include genre to the genre property if for some reason the website doesn't include it
      genre && !movie.genres.include?(genre) && movie.genres << genre
    end
  end

  def self.get_movie_details_page(movie_url)
    response = HTTParty.get(movie_url)
    Nokogiri::HTML(response.body)
  end
end
