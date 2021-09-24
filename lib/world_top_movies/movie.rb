class WorldTopMovies::Movie
  attr_reader :award, :storyline, :languages, :official_site, :countries_of_orig

  @@all = []

  def initialize(attributes)
    #Utilises metaprogramming to create new instances
    attributes.each do |key, value|
      self.class.attr_accessor(key)
      self.send(("#{key}="), value)
    end
    # Add instance to @all only if it's not already there
    self.class.all << self if self.class.all.none? { |m| m.url == self.url } && !self.database
  end

  def self.new_from_page(m)
    # Creates new instance with the attributes from general page
    self.new({
      title: m.css("h3 a").text,
      year: m.css("h3 span.lister-item-year").text[1...-1].scan(/[0-9]/).join(),
      duration: m.css("span.runtime").text,
      genres: m.css("span.genre").text.strip.split(", "),
      user_rating: m.css("div strong").text.to_f,
      metascore: m.css("div span.metascore").text.strip.to_i,
      description: m.css("p.text-muted")[1].text.strip,
      director: m.css("div.lister-item-content p a")[0].text.strip,
      stars: m.css("div.lister-item-content p a").slice(1..-1).map { |s| s.text },
      votes: m.css("p.sort-num_votes-visible span")[1].text.gsub(",", "").to_i,
      gross_revenue: m.css("p.sort-num_votes-visible span")[-1].text,
      url: "https://imdb.com" + m.css("h3 a").attribute("href").value,
      database: false,
    })
  end

  def self.all
    @@all
  end

  def self.all_top_general
    # Filters out the movies with rating >= 8.4
    self.all.select { |m| m.user_rating >= 8.4 }.sort_by { |m| m.user_rating }.reverse
  end

  def self.all_by_genre(genre)
    # Filters all movies from a given genre, if no genre, return general movies
    return self.all_top_general if !genre
    self.all.select { |m| m.genres.include?(genre) }
  end

  def self.reset_all
    self.all.clear
  end

  def self.all_titles_and_links_hash
    # returns a hash with key=title, value=url of all movie instances
    result = {}
    self.all.each do |m|
      result[m.title] = m.url
    end
    result
  end

  def self.all_titles_and_links_hash_by_genre(genre)
    # returns a hash with key=title, value=url of all movie instances from given genre
    result = {}
    counter = 1
    self.all_by_genre(genre).each do |m|
      if result.keys.none? { |key| key == m.title }
        result[m.title] = m.url
      else
        result[m.title + "(#{counter + 1})"] = m.url
      end
    end

    result
  end

  def self.find_by_url(url)
    self.all.find { |m| m.url == url }
  end

  def self.delete_movie_instance_from_user(user:, movie_url:)
    user.movies.delete(user.find_movie_from_url(movie_url))
  end

  def self.scrape_and_print_movies_compact(genre = nil)
    # Looks for the movies to print depending on the arg and prints title, rating, year
    if genre == "all"
      movies = self.all.sort_by { |m| m.user_rating }.reverse
    else
      WorldTopMovies::Scraper.make_movies(genre)
      movies = genre == nil ? self.all_top_general : self.all_by_genre(genre)
    end
    puts "I'll give you #{movies.size} top movies!"
    sleep(1.5)
    movies.each_with_index do |movie, index|
      sleep(0.01)
      self.print_movie_compact(movie, index)
    end
  end

  def self.print_movie_compact(movie, index)
    puts "--------------------------------------------------------------"
    puts "\n#{index + 1}. #{movie.title.colorize(:color => :green, :mode => :bold)}, \
Rating: #{movie.user_rating.to_s.colorize(:color => :light_blue, :mode => :bold)}, \
Year: #{movie.year.colorize(:color => :red)} \n"
  end

  def get_awards_count
    target = doc.css("li span.ipc-metadata-list-item__list-content-item")[0].text
    @award || (@award = target if target.include?("nomination") || target.include?("win"))
  end

  def storyline
    @storyline ||
    @storyline = doc.css(
      ".Storyline__StorylineWrapper-sc-1b58ttw-0 div.ipc-html-content.ipc-html-content--base div"
    )[0].text
  end

  def languages
    @languages ||
    @languages = doc.css(
      "div[data-testid=title-details-section] li[data-testid=title-details-languages]"
    )
      .children[1].children[0].children.map { |l| l.text }.join(" - ")
  end

  def official_site
    target = doc.css(
      "div[data-testid=title-details-section] li[data-testid=title-details-officialsites]"
    )
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
    @countries_of_origin = doc.css("div[data-testid=title-details-section] li[data-testid=title-details-origin]")
      .children[1].children[0].children.map { |c| c.text }.join(" - ")
  end

  def scrape_and_print_movie
    # Prints detailed info of a selected movie from select_specific_movie, after scraping it.
    description = self.description
    storyline = self.storyline
    puts "\n----------------------------------------------"
    puts "         #{self.title.upcase} - #{self.year}         ".colorize(:background => :green, :color => :black).bold
    puts "----------------------------------------------"
    puts "\n#{"Genres:".bold}       #{self.genres.class == Array && self.genres.join(" - ").green.italic || self.genres.green.italic}"
    puts "#{"Duration:".bold}     #{self.duration.green.italic}"
    puts "#{"Stars:".bold}        #{self.stars.class == Array && self.stars.join(" - ").green.italic || self.stars.green.italic}"
    puts "#{"Rating:".bold}       #{"#{self.user_rating} from #{self.votes} votes".green.italic}"
    puts "#{"Metascore:".bold}    #{self.metascore && self.metascore.to_s.green.italic || "N/A"}"
    puts "#{"Directed by:".bold}  #{self.director && self.director.green.italic}"
    puts "#{"Total Awards:".bold} #{self.get_awards_count && self.get_awards_count.green.italic || "N/A"}"
    puts "\n-----------------#{"Description".bold}-------------------"
    puts "\n#{description.green.italic || "N/A"}\n"
    puts "\n#{"Storyline:".bold}\n\n#{self.storyline && self.storyline.green.italic || "N/A"}\n"
    puts "\n----------------#{"Other Details".bold}------------------"
    puts "\n#{"Countries:".bold}    #{self.countries_of_origin && self.countries_of_origin.green.italic || "N/A"}"
    puts "#{"Languages:".bold}    #{self.languages && self.languages.green.italic || "N/A"}"
    puts "#{"IMDB URL:".bold}     #{self.url.green.italic}"
    puts "#{"Website:".bold}      #{self.official_site && self.official_site.green.italic || "N/A"}"
    puts "\nThis movie has a gross revenue of #{self.gross_revenue}".green.bold
  end

  private

  def doc
    @doc || @doc = WorldTopMovies::Scraper.get_movie_details_page(self.url)
  end
end
