class WorldTopMovies::Movie
  attr_accessor :title, :year, :duration, :genre, :user_rating, :metascore, :description, :director, :stars, :votes, :gross_revenue, :link
  
  @@all =[]

  def initialize
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.reset_all
    @all.clear
  end

end