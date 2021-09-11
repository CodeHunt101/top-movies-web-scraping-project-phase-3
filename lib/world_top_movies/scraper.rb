class WorldTopMovies::Scraper
  attr_accessor :genre
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

  def initialize(genre = nil)
    @genre = genre
  end

  def self.genres
    @@genres
  end

  def genre
    @genre ? @genre.downcase : nil
  end
  
  def get_top_movies_page
    response = HTTParty.get("https://www.imdb.com/search/title/?title_type=feature&num_votes=200000,&genres=#{self.genre}&sort=user_rating,desc&view=advanced")
    Nokogiri::HTML(response.body)
  end

  def get_movies
    self.get_top_movies_page.css("div.lister-item.mode-advanced")
  end

  def make_movies
    self.get_movies.each do |m|
      movie = WorldTopMovies::Movie.new_from_page(m)
      # Fix error from website. Include genre to the genre property if for some reson it's not there
      self.genre && !movie.genre.include?(self.genre.capitalize) && movie.genre << self.genre.capitalize
    end
  end

  def self.get_movie_details_page(movie_url)
    response = HTTParty.get(movie_url)
    Nokogiri::HTML(response.body)
  end

end