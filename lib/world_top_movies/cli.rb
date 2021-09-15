class WorldTopMovies::CLI
  
  attr_accessor :username, :movie_instance, :genre, :status
  
  @@prompt = TTY::Prompt.new
  
  def self.prompt
    @@prompt
  end
  
  def run
      introduce if !self.username
      scrape_and_generate_movies  if self.status != "exit"
      print_movies_compact(self.genre) if self.status != "exit"
      restart if self.status != "exit"
  end

  private #: set to private once project finished

  def introduce
    artii = Artii::Base.new({})
    puts '-----------------------------------------------------------------------------------'
    puts artii.asciify('World Top Movies!')
    puts '-----------------------------------------------------------------------------------'
    puts "    By Harold Torres Marino | p: +61 401 927 123 | e: haroldtm55@gmail.com".colorize(:mode=>:italic)
    puts '-----------------------------------------------------------------------------------'
    sleep(0.5)
    puts "Hey! Do you like movies??!"
    sleep(1.5)
    puts "I'm sure you do!"
    sleep(1.5)
    puts "Let me tell you something..."
    sleep(1.5)
    puts "Here you can see the top movies of all times! ;)"
    sleep(2)
    self.username = self.class.prompt.ask("May I have your name, please?") do |q|
      q.required(true, "Oops, seems you haven't provided your name. Try again please.")
      q.validate(/^[a-zA-Z]+$/, "Invalid name, please try again.")
      q.modify   :capitalize
    end
    puts "Thanks #{self.username}. I'd like to ask you some questions, ok?"
  end

  def scrape_and_generate_movies
    sleep(1.5)
    type_of_scrape = self.class.prompt.select(
      "Would you like to see the list of all movies in general or by genre?",
      %w(General Genre))
    puts "Alright! We're going to see the top #{type_of_scrape} movies..."
    sleep(1.5)
    self.genre = nil if type_of_scrape == "General"
    type_of_scrape == "Genre" && (
      self.genre = self.class.prompt.enum_select(
        "Choose a genre:", WorldTopMovies::Scraper.genres
      )
    )
    WorldTopMovies::Scraper.make_movies(self.genre)
  end 

  def print_movies_compact(genre = nil)
    if genre == "all"
      movies = WorldTopMovies::Movie.all.sort_by{|m| m.user_rating}.reverse
    else
      movies = genre == nil ? WorldTopMovies::Movie.all_top_general : WorldTopMovies::Movie.all_by_genre(genre)
    end
    puts "\nI'll give you #{movies.size} top movies!"
    sleep(1.5)
    movies.each_with_index do |m,i|
      sleep(0.01)
      puts "--------------------------------------------------------------"
      puts "\n#{i+1}. #{m.title.colorize(:color => :green, :mode=> :bold)},\
  Rating: #{m.user_rating.to_s.colorize(:color => :light_blue, :mode=> :bold)},\
  Year: #{m.year.colorize(:color => :red)} \n"
    end
  end

  def select_specific_movie
    sleep(0.5)
    movie_url = self.class.prompt.enum_select(
      "Select a movie: ", WorldTopMovies::Movie.all_titles_and_links_hash_by_genre(self.genre))
    self.movie_instance = WorldTopMovies::Movie.find_by_url(movie_url)
  end

  def scrape_and_print_chosen_movie
    # These two variables take some time to load, so I call them before they are printed to show everything at the same time
    description = self.movie_instance.description
    storyline = self.movie_instance.storyline
    puts "\n----------------------------------------------"
    puts "         #{self.movie_instance.title.upcase} - #{self.movie_instance.year}"
    puts "----------------------------------------------"
    puts "\nGenres:       #{self.movie_instance.genres.join(" - ") || "N/A"}"
    puts "Duration:     #{self.movie_instance.duration}"
    puts "Stars:        #{self.movie_instance.stars.join(" - ")}"
    puts "Rating:       #{self.movie_instance.user_rating} from #{self.movie_instance.votes} votes"
    puts "Metascore:    #{self.movie_instance.metascore || "N/A"}"
    puts "Directed by:  #{self.movie_instance.director}"
    puts "Total Awards: #{self.movie_instance.get_awards_count || "N/A"}"
    puts "\n-----------------Description-------------------"
    puts "\n#{description || "N/A"}\n"
    puts "\nStoryline:\n#{storyline || "N/A"}\n"
    puts "\n----------------Other Details------------------"
    puts "\nCountries:    #{self.movie_instance.countries_of_origin || "N/A"}"
    puts "Languages:    #{self.movie_instance.languages || "N/A"}"
    puts "IMDB URL:     #{self.movie_instance.url}"
    puts "Website:      #{self.movie_instance.official_site || "N/A"}"
    puts "\nThis movie has a gross revenue of #{self.movie_instance.gross_revenue}"
  end

  def close_app
    self.status = "exit"
    puts "\nOk #{self.username}, hope you enjoyed your time with me!"
  end

  def restart
    puts ""
    sleep(0.5)
    options = [
      "See more info of a movie from the last selected genre or general list", 
      "Start a new lookup", 
      "Print all the movies displayed so far and exit", 
      "Exit" ]

    next_action = self.class.prompt.select(
      "What would you like to do now?", options
    )
    
    if next_action == options[0]
      select_specific_movie
      scrape_and_print_chosen_movie
      restart
    elsif next_action == options[1]
      run
    elsif next_action == options[2]
      print_movies_compact("all")
      restart
      # close_app
      # Check whether it's better call bye prompt or restart
    else
      close_app
    end
  end
  
end