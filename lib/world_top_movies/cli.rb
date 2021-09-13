class WorldTopMovies::CLI
  @@prompt = TTY::Prompt.new
    attr_accessor :name, :movie_instance, :genre
  def self.prompt
    @@prompt
  end
  
  def run
    introduce
    scrape_and_generate_movies 
    print_movies_compact 
    select_specific_movie
    scrape_and_print_chosen_movie
    # restart
  end

  # private : set to private once project finished

  def introduce
    artii = Artii::Base.new({})
    puts '-----------------------------------------------------------------------------------'
    puts artii.asciify('World Top Movies!')
    puts '-----------------------------------------------------------------------------------'
    puts "    By Harold Torres Marino | p: +61 401 927 123 | e: haroldtm55@gmail.com"
    puts '-----------------------------------------------------------------------------------'
    # sleep(0.5)
    puts "Hey! Do you like movies??!"
    # sleep(1.5)
    puts "I'm sure you do!"
    # sleep(1.5)
    puts "Let me tell you something..."
    # sleep(1.5)
    puts "Here you can see the top movies of all times! ;)"
    # sleep(2)
    @name = self.class.prompt.ask("May I have your name, please?") do |q|
      q.required(true, "Oops, seems you haven't provided your name. Try again please.")
      q.validate(/[a-zA-Z]+$/, "Invalid name, please try again.")
      q.modify   :capitalize
    end
    puts "Thanks #{@name}. I'd like to ask you some questions, ok?"
  end

  def scrape_and_generate_movies
    # sleep(1.5)
    type_of_scrape = self.class.prompt.select(
      "Would you like to see the list of all movies in general or by genre?",
      %w(General Genre))
    puts "Alright! We're going to see the top #{type_of_scrape} movies..."
    
    @genre = nil if type_of_scrape == "General"

    type_of_scrape == "Genre" && (
      @genre = self.class.prompt.enum_select(
        "Choose a genre:", WorldTopMovies::Scraper.genres
      )
    )
    WorldTopMovies::Scraper.new(@genre).make_movies
  end 

  def print_movies_compact(genre = nil)
    puts "\nI'll give you #{WorldTopMovies::Movie.all.size} top movies!"
    # sleep(1.5)
    WorldTopMovies::Movie.all.each_with_index do |m,i|
      # sleep(0.025)
      puts "--------------------------------------------------------------"
      puts "\n#{i+1}. #{m.title.colorize(:color => :green, :mode=> :bold)},\
 Rating: #{m.user_rating.to_s.colorize(:color => :light_blue, :mode=> :bold)},\
 Year: #{m.year.colorize(:color => :red)} \n"
    end
  end

  def select_specific_movie
    details = self.class.prompt.yes?("Would you like to see more info of any of these movies?")
    return self.bye_propmt if !details
    movie_url = self.class.prompt.enum_select(
      "Select a movie: ", WorldTopMovies::Movie.all_titles_and_links_hash)
    @movie_instance = WorldTopMovies::Movie.find_by_url(movie_url)
  end

  def scrape_and_print_chosen_movie
    puts "\n----------------------------------------------"
    puts "         #{@movie_instance.title.upcase} - #{@movie_instance.year}"
    puts "----------------------------------------------"
    puts "\nGenres:       #{@movie_instance.genres.join(" - ") || "N/A"}"
    puts "Duration:     #{@movie_instance.duration}"
    puts "Stars:        #{@movie_instance.stars.join(" - ")}"
    puts "Rating:       #{@movie_instance.user_rating} from #{@movie_instance.votes} votes"
    puts "Metascore:    #{@movie_instance.metascore || "N/A"}"
    puts "Directed by:  #{@movie_instance.director}"
    puts "Total Awards: #{@movie_instance.get_awards_count || "N/A"}"
    puts "\n-----------------Description-------------------"
    puts "\n#{@movie_instance.description || "N/A"}\n"
    puts "\nStoryline:\n#{@movie_instance.storyline || "N/A"}\n"
    puts "\n----------------Other Details------------------"
    puts "\nCountries:  #{@movie_instance.countries_of_origin || "N/A"}"
    puts "Languages:    #{@movie_instance.languages || "N/A"}"
    puts "IMDB URL:     #{@movie_instance.url}"
    puts "Website:      #{@movie_instance.official_site || "N/A"}"
    puts "\nThis movie has a gross revenue of #{@movie_instance.gross_revenue}"
  end

  def bye_propmt
    puts "Ok #{@name}, hope you enjoyed your time with me!"
  end

  def restart
    options = [
      "See more info from another movie in the last list", 
      "Start a new lookup", 
      "Print all the movies displayed so far", 
      "Exit" ]
    
    puts "genre is #{!@genre}"
    next_action = self.class.prompt.select(
      "What would you like to do now?", options
    )
    
    if next_action == options[0]
      run
    elsif next_action == options[1]
      @genre = ""
      run
    elsif next_action == options[2]
      print_movies_compact
    else
      bye_propmt
    end

    # next_action_options[next_action]  why this doesn't work?

    # next_action == options[0] && select_specific_movie
    # next_action == options[1] && run
    # next_action == options[2] && print_movies_compact
    # next_action == option[3] && bye_propmt

  end

  def next_action_options
    hash = {
      "See more info from another movie in the last list"=> select_specific_movie,
      "Start a new lookup"=> run,
      "Print all the movies displayed so far"=> print_movies_compact,
      "Exit"=> bye_propmt
    }

  end
  

end