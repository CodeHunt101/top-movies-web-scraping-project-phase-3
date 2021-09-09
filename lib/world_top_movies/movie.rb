class WorldTopMovies::Movie
  attr_accessor :id, :title, :year, :imdb_rating, :link, :description, :director, :genre
  
  @@all =[]

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset_all
    @all.clear
  end
end