class WorldTopMovies::Scraper
  attr_accessor :genre
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

  def initialize(genre = nil)
    @genre = genre
  end

  def self.genres
    @@genres
  end

  def genre
    @genre
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
      movie = WorldTopMovies::Movie.new
      movie.title = m.css("h3 a").text
      movie.year = m.css("h3 span.lister-item-year").text[1...-1]
      movie.duration = m.css("span.runtime").text
      movie.genre = m.css("span.genre").text.strip.split(", ")
      movie.user_rating = m.css("div strong").text.to_f
      movie.metascore = m.css("div span.metascore").text.strip.to_i
      movie.description = m.css("p.text-muted")[1].text.strip
      movie.director = m.css("div.lister-item-content p a")[0].text.strip
      movie.stars = m.css("div.lister-item-content p a").slice(1..-1).map{|s| s.text}
      movie.votes = m.css("p.sort-num_votes-visible span")[1].text.gsub(",","").to_i
      movie.gross_revenue = m.css("p.sort-num_votes-visible span")[-1].text
      movie.link = "https://imdb.com" + m.css("h3 a").attribute("href").value
      # binding.pry

    end
    # binding.pry

  end

end

# movies = WorldTopMovies::Scraper.new
# movies.make_movies("comedy")
# movies.get_top_movies_page("comedy")
# puts "This is light blue".colorize(:light_blue)