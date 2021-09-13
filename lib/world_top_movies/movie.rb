class WorldTopMovies::Movie
  attr_accessor :award, :storyline, :languages, :official_site, :countries_of_origin
  
  @@all =[]
  
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
      genres: m.css("span.genre").text.strip.split(", "),
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
  
  def self.all
    @@all
  end

  def self.reset_all
    self.all.clear
  end

  def self.all_titles_and_links_hash
    result = {}
    self.all.each do |m|
      result[m.title] = m.url
    end
    result
  end

  def self.find_by_url(url)
    self.all.find {|m| m.url == url}
  end
  
  def get_awards_count
    target = self.doc.css('li span.ipc-metadata-list-item__list-content-item')[0].text
    @award || (@award = target if target.include?('nomination') || target.include?('win'))
    # @award if @award.include?('nomination') || @award.include?('win')
  end

  def storyline
    @storyline ||
    @storyline = self.doc.css(
      ".Storyline__StorylineWrapper-sc-1b58ttw-0 div.ipc-html-content.ipc-html-content--base div")[0].text
  end

  def languages
    @languages ||
    @languages = self.doc.css(
      'div[data-testid=title-details-section] li[data-testid=title-details-languages]')
      .children[1].children[0].children.map {|l| l.text}.join(" - ")
  end

  def official_site
    target = self.doc.css(
      'div[data-testid=title-details-section] li[data-testid=title-details-officialsites]')
      .children
    if @official_site
      @official_site
    else 
      if target.children[0] && target.children[0].text.include?("site")
        @official_site = target.children[1].children[0].children[0].attribute("href").value 
      end
    end
  end

  def countries_of_origin
    @countries_of_origin || 
    @countries_of_origin = self.doc.css('div[data-testid=title-details-section] li[data-testid=title-details-origin]')
    .children[1].children[0].children.map {|c| c.text}.join(" - ")
  end

  def doc
    @doc || @doc = WorldTopMovies::Scraper.get_movie_details_page(self.url) 
  end

end