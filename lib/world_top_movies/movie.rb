class WorldTopMovies::Movie
  
  @@all =[]
  
  def self.all
    @@all
  end

  def self.reset_all
    self.all.clear
  end
  
  def initialize(attributes)
    attributes.each do |key, value|
      self.class.attr_accessor(key)
      self.send(("#{key}="), value)
    end
    # Add instance to @all only if it's not already there
    self.class.all << self if WorldTopMovies::Movie.all.none?{|m| m.url == self.url}
  end

  def self.new_from_page(m)
    self.new({
      title: m.css("h3 a").text,
      year: m.css("h3 span.lister-item-year").text[1...-1].scan(/[0-9]/).join(),
      duration: m.css("span.runtime").text,
      genre: m.css("span.genre").text.strip.split(", "),
      user_rating: m.css("div strong").text.to_f,
      metascore: m.css("div span.metascore").text.strip.to_i,
      description: m.css("p.text-muted")[1].text.strip,
      director: m.css("div.lister-item-content p a")[0].text.strip,
      stars: m.css("div.lister-item-content p a").slice(1..-1).map{|s| s.text},
      votes: m.css("p.sort-num_votes-visible span")[1].text.gsub(",","").to_i,
      gross_revenue: m.css("p.sort-num_votes-visible span")[-1].text,
      url: "https://imdb.com" + m.css("h3 a").attribute("href").value,
    })
  end

  def all_genres
    @genre.join(" - ")
  end

  def stars
    @stars.join(" - ")
  end

  def get_awards_count
    award = WorldTopMovies::Scraper.get_movie_details_page(self.url).css(
      'li span.ipc-metadata-list-item__list-content-item')[0].text
    award if award.include?('win' || 'nomination')
  end

  def storyline
    WorldTopMovies::Scraper.get_movie_details_page(self.url).css(
      'div.ipc-html-content.ipc-html-content--base div')[0].text
  end

  def details
    details_list = WorldTopMovies::Scraper.get_movie_details_page(self.url).css('div[data-testid=title-details-section] ul')
    {
      countries_of_origin: details_list[2].children.map {|c| c.text}.join(" - "),
      official_site: details_list[3].children[0].children[0].attribute("href").value,
      languages: details_list[4].children.map {|l| l.text}.join(" - "),
    }
  end

end