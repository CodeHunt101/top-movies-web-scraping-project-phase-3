class WorldTopMovies::CLI
  
  attr_accessor :user, :movie_instance, :genre, :status
  
  @@prompt = TTY::Prompt.new
  
  def self.prompt
    @@prompt
  end
  
  def run
    introduce if !self.user
    run_favourite_movies_section if self.status != "exit"
    scrape_and_print_movies  if self.status != "exit"
    select_next_action if self.status != "exit"
  end

  # private #: set to private once project finished

  def introduce
    # Introduces the app and ask for user credentials
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
    username = self.class.prompt.ask("Please enter your username to log in or sign up") do |q|
      q.required(true, "Oops, seems you haven't provided your username! Try again please.")
      q.validate(/^[a-zA-Z0-9._-]+$/, "Oops, seems like that username is invalid. Only alphanumerical characters plus . - _ are allowed. Try again please.")
      q.modify   :down
    end
    self.user = WorldTopMovies::DB::User.find_or_create_by(username: username)
    puts "Thanks #{username}. I'd like to ask you some questions, ok?"
  end

  def scrape_and_print_movies
    # Asks the user which genre they want to see, then scrapres and generates the instances
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
    WorldTopMovies::Movie.scrape_and_print_movies_compact(self.genre)
  end 

  def select_and_print_specific_movie
    # Asks user to select a movie from print_movies_compact
    sleep(0.5)
    movie_url = self.class.prompt.enum_select(
      "Select a movie: ", WorldTopMovies::Movie.all_titles_and_links_hash_by_genre(self.genre))
    self.movie_instance = WorldTopMovies::Movie.find_by_url(movie_url)
    self.movie_instance.scrape_and_print_movie
  end

  def close_app
    self.status = "exit"
    puts "\nOk #{self.user.username}, hope you enjoyed your time with me!"
  end

  def select_next_action
    # Ask user to select a new action and re run the app from the chosen action
    puts ""
    sleep(0.5)
    options = [
      "See more info of a movie from the last selected genre or general list", 
      "Add favourite movies from the last selected genre or general list",
      "Start a new lookup", 
      "Go to favourite movies section",
      "Print all the movies displayed so far", 
      "Exit" ]

    next_action = self.class.prompt.select(
      "What would you like to do now?", options
    )
    if next_action == options[0]
      select_and_print_specific_movie
      add_favourite_movie
      select_next_action
    elsif next_action == options[1]
      add_favourite_movies
      select_next_action
    elsif next_action == options[2]
      scrape_and_print_movies   
      select_next_action 
    elsif next_action == options[3]
      run_favourite_movies_section
      select_next_action
    elsif next_action == options[4]
      WorldTopMovies::Movie.scrape_and_print_movies_compact("all")
      select_next_action
    else
      close_app
    end
  end
  
  def add_favourite_movies
    # Finds or creates a new Favourite movie instances and adds them to the database
    movie_urls = self.class.prompt.multi_select(
      # TODO: Maybe better to order alphabetically
      "\nSelect movies: ", WorldTopMovies::Movie.all_titles_and_links_hash_by_genre(self.genre))
    movie_urls.each do |movie_url|
      if self.user.movies.none?{|m| m.url == movie_url}
        fav_movie = WorldTopMovies::Movie.find_by_url(movie_url)
        self.user.movies << WorldTopMovies::DB::Movie.find_or_create_by(title: fav_movie.title, url: fav_movie.url)
      end
    end
    puts "\nThe movie(s) have been added to your favourites!"
  end

  def add_favourite_movie
    # Finds or creates a new Favourite movie instance and adds it to the database
    add_to_favourite = self.class.prompt.yes?("\nWould you like to add this movie to your favourites?")
    if add_to_favourite && self.user.movies.none?{|m| m.url == self.movie_instance.url}
      self.user.movies << WorldTopMovies::DB::Movie.find_or_create_by(title: self.movie_instance.title, url: self.movie_instance.url)
      puts "#{self.movie_instance.title} has been added to your favourite movies!"
    else 
      add_to_favourite && puts("Oops! #{self.movie_instance.title} is already in your favourites!")
    end
  end

  def delete_favourite_movies
    !self.user.movies.empty? && delete_favourites = self.class.prompt.yes?("\nWould you like to delete any of your favourite movies?")
    if delete_favourites
      movie_urls = self.class.prompt.multi_select(
        "\nSelect movies: ", self.user.favourite_movie_titles)
      movie_urls.each do |movie_url|
        WorldTopMovies::DB::UserMovie.joins(:user, :movie)
        .where("movies.url" => movie_url, "users.username" => self.user.username).destroy_all
        self.user.movies.delete(self.user.find_movie_from_url(movie_url))
      end
      puts "The movie(s) have been successfully deleted"
    end
  end

  def run_favourite_movies_section
    favourite_movies = self.class.prompt.yes?("\nWould you like to see all your favourite movies?")
    favourite_movies && self.user.print_all_favourite_movie_titles && delete_favourite_movies
  end
end