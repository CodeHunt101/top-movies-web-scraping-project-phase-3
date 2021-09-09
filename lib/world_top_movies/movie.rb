class WorldTopMovies::Movie
  attr_accessor :id, :title, :year, :duration, :genre, :user_rating, :description, :director, :stars, :votes, :gross, :link,
  
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