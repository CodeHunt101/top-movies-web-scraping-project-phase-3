class WorldTopMovies::CLI
  attr_accessor :movie_instance, :genre, :status

  @@prompt = TTY::Prompt.new
  @@user = nil

  def self.prompt
    @@prompt
  end

  def self.user
    @@user
  end

  def run
    introduce
    select_movies_lookup_or_fav_movies
  end

  private

  def introduce
    # Introduces the app and ask for user credentials
    artii = Artii::Base.new({})
    puts "-----------------------------------------------------------------------------------"
    puts artii.asciify("World's Top Movies!")
    puts "-----------------------------------------------------------------------------------"
    puts "    By Harold Torres Marino | p: +61 401 927 123 | e: haroldtm55@gmail.com".colorize(:mode => :italic)
    puts "-----------------------------------------------------------------------------------"
    sleep(0.5)
    puts "\nWelcome to the World's Top Movies of all times, a place where you can look up for worldwide top rated movies!\n\n"
    sleep(1.5)
    username = self.class.prompt.ask("Please enter your username to log in or sign up: ") do |q|
      q.required(true, "Oops, seems you haven't provided your username! Try again please.")
      q.validate(/^[a-zA-Z0-9._-]+$/, "Oops, seems like that username is invalid. Only alphanumerical characters plus . - _ are allowed. Try again please.")
      q.modify(:down)
    end
    @@user = WorldTopMovies::DB::User.find_or_create_by(username: username)
    sleep(0.5)
    puts "\nThanks #{username}. I'd like to ask you some questions, ok?"
  end

  def select_movies_lookup_or_fav_movies
    options = [
      "Top Movies Lookup",
      "My Favourite Movies section",
      "My Movie Notes",
      "Exit app",
    ]
    next_action = self.class.prompt.select(
      "\nPlease choose where you want to go...", options
    )
    next_action == options[0] && scrape_and_print_movies
    next_action == options[1] && select_action_favourite_movies
    next_action == options[2] && select_action_movies_with_notes
    next_action == options.last && close_app
    select_next_action
  end

  def scrape_and_print_movies
    # Asks the user which genre they want to see, then scrapres and generates the instances
    sleep(1.5)
    puts ""
    type_of_scrape = self.class.prompt.select(
      "Would you like to see the list of all movies in general or by genre?",
      %w(General Genre)
    )
    puts "\nAlright! We're going to see the top #{type_of_scrape} movies..."
    puts ""
    sleep(1.5)
    self.genre = nil if type_of_scrape == "General"
    type_of_scrape == "Genre" && (self.genre = self.class.prompt.select(
      "Choose a genre:\n", WorldTopMovies::Scraper.genres
    ))
    WorldTopMovies::Movie.scrape_and_print_movies_compact(self.genre)
  end

  def select_next_action
    # Ask user to select a new action and re run the app from the chosen action
    puts ""
    sleep(0.5)
    options = [
      "See more info of a movie from the last selected genre or general list",
      "Add favourite movies from the last selected genre or general list",
      "Start a new lookup",
      "Go to My Favourite Movies section",
      "Go to My Movie notes",
      "Print all the movies displayed so far",
      "Exit app",
    ]

    next_action = self.class.prompt.select(
      "What would you like to do now?", options
    )
    if next_action == options[0]
      select_and_print_specific_movie
      add_fav_or_leave_note
    end
    next_action == options[1] && add_favourite_movies
    next_action == options[2] && scrape_and_print_movies
    next_action == options[3] && select_action_favourite_movies
    next_action == options[4] && select_action_movies_with_notes
    next_action == options[5] && WorldTopMovies::Movie.scrape_and_print_movies_compact("all")
    next_action == options.last && close_app
    select_next_action
  end

  def select_and_print_specific_movie
    # Asks user to select a movie from print_movies_compact
    sleep(0.5)
    puts ""
    movie_url = self.class.prompt.select(
      "Select a movie: ", WorldTopMovies::Movie.all_titles_and_links_hash_by_genre(self.genre), enum: ")",
    )
    self.movie_instance = WorldTopMovies::Movie.find_by_url(movie_url)
    self.movie_instance.scrape_and_print_movie
  end

  def add_favourite_movies
    # Finds or creates a new Favourite movie instances and adds them to the database
    sleep(0.5)
    movie_urls = self.class.prompt.multi_select(
      "\nSelect movies: ", WorldTopMovies::Movie.all_titles_and_links_hash_by_genre(self.genre), enum: ")",
    )
    WorldTopMovies::DB::Movie.add_movies(user: self.class.user, movie_urls: movie_urls)
    movie_urls.size > 0 ? puts("\nThe movie(s) have been added to your favourites!") : puts("\nNo movies were selected.")
  end

  def add_fav_or_leave_note
    options = [
      "Add it to your favourites",
      "Leave a note",
      "Nothing in particular",
    ]
    puts ""
    next_action = self.class.prompt.select(
      "What would you like to do with this movie?", options
    )
    next_action == options[0] && add_favourite_movie
    next_action == options[1] && leave_note
    select_next_action
  end

  def leave_note
    note_message = self.class.prompt.ask("Please leave your note\n\n") do |q|
      q.required(true, "Oops, seems you haven't left any note! Try again please.")
    end
    WorldTopMovies::DB::Note.create_note(movie_url: self.movie_instance.url, note_message: note_message, user: self.class.user)
    puts "\nYour note has been saved!"
    sleep(1.5)
  end

  def add_favourite_movie
    # Finds or creates a new Favourite movie instance and adds it to the database
    sleep(0.5)
    if self.class.user.movies.none? { |m| m.url == self.movie_instance.url }
      WorldTopMovies::DB::Movie.add_movies(user: self.class.user, movie_urls: self.movie_instance.url)
      puts "\n#{self.movie_instance.title} has been added to your favourite movies!"
    else
      puts("\nOops! #{self.movie_instance.title} is already in your favourites!")
    end
  end

  def delete_favourite_movies
    sleep(0.5)
    if self.class.user.movies.empty?
      puts "\nOops, you haven't favourited any movies yet!!"
    else
      movie_urls = self.class.prompt.multi_select(
        "\nSelect movies: ", self.class.user.favourite_movie_titles, enum: ")",
      )
      movie_urls.each do |movie_url|
        WorldTopMovies::DB::UserMovie.delete_movie_record_from_user(user: self.class.user, movie_url: movie_url)
        WorldTopMovies::Movie.delete_movie_instance_from_user(user: self.class.user, movie_url: movie_url)
      end
      movie_urls.size > 0 ? puts("\nThe movie(s) have been successfully deleted") : puts("\nNo movies were selected.")
    end
  end

  def print_favourite_movies
    sleep(1)
    if !self.class.user.movies.empty?
      self.class.user.print_all_favourite_movie_titles
    else
      puts "\nOops, you haven't favourited any movies yet!!"
    end
  end

  def select_and_print_specific_favourite_movie
    # Asks user to select a movie from print_movies_compact
    sleep(0.5)
    if self.class.user.movies.empty?
      puts "\nOops, you haven't favourited any movies yet!!"
    else
      puts ""
      movie_url = self.class.prompt.select(
        "Select a movie: ", self.class.user.favourite_movie_titles, enum: ")",
      )
      WorldTopMovies::DB::Movie.all.find { |m| m.url == movie_url }.print_movie_details
    end
  end

  def select_action_favourite_movies
    puts ""
    if self.class.user.movies.empty?
      puts "Oops, you haven't favourited any movies yet, let's change that!!"
      scrape_and_print_movies
      select_next_action
    else
      sleep(0.5)
      options = [
        "See all your favourite movies",
        "See more info of any of your favourite movies",
        "Delete any of your favourite movies",
        "Take me to the top movies lookup",
        "Exit app",
      ]

      next_action = self.class.prompt.select(
        "What would you like to do now?", options
      )
      if next_action == options[0]
        print_favourite_movies
        select_action_favourite_movies
      elsif next_action == options[1]
        select_and_print_specific_favourite_movie
        select_action_favourite_movies
      elsif next_action == options[2]
        delete_favourite_movies
        select_action_favourite_movies
      elsif next_action == options[3]
        scrape_and_print_movies
        select_next_action
      else
        close_app
      end
    end
  end

  def print_all_notes
    if !self.class.user.notes.empty?
      self.class.user.print_all_notes
    else
      puts "\nOops, you haven't left any notes yet!!"
    end
  end

  def print_movies_with_notes
    sleep(1)
    if !self.class.user.notes.empty?
      self.class.user.print_movies_with_notes
    else
      puts "\nOops, you haven't left any notes yet!!"
    end
  end

  def select_and_print_specific_movie_with_notes
    # Asks user to select a movie from print_movies_compact
    sleep(0.5)
    if self.class.user.notes.empty?
      puts "\nOops, you haven't left any notes yet!!"
    else
      puts ""
      movie_url = self.class.prompt.select(
        "Select a movie: ", self.class.user.movies_with_notes_titles, enum: ")",
      )
      WorldTopMovies::DB::Movie.all.find { |m| m.url == movie_url }.print_movie_details
    end
  end

  def delete_notes
    sleep(0.5)
    if self.class.user.movies.empty?
      puts "\nOops, you haven't left any notes yet!!"
    else
      note_ids = self.class.prompt.multi_select(
        "\nSelect notes: ", self.class.user.notes_titles, enum: ")",
      )
      note_ids.each do |note_id|
        WorldTopMovies::DB::UserNote.delete_note_record_from_user(user: self.class.user, note_id: note_id)
        WorldTopMovies::DB::Note.delete_note_instance_from_user(user: self.class.user, note_id: note_id)
      end
      note_ids.size > 0 ? puts("\nThe note(s) have been successfully deleted") : puts("\nNo notes were selected.")
    end
  end

  def select_action_movies_with_notes
    puts ""
    if self.class.user.notes.empty?
      puts "Oops, you haven't left any notes yet, let's change that!!"
      scrape_and_print_movies
      select_next_action
    else
      sleep(0.5)
      options = [
        "See all my notes",
        "See all your movies with notes",
        "Open specific movie with notes",
        "Delete any of your notes",
        "Take me to the top movies lookup",
        "Exit app",
      ]

      next_action = self.class.prompt.select(
        "What would you like to do now?", options
      )
      if next_action == options[0]
        print_all_notes
        select_action_movies_with_notes
      elsif next_action == options[1]
        print_movies_with_notes
        select_action_movies_with_notes
      elsif next_action == options[2]
        select_and_print_specific_movie_with_notes
        select_action_movies_with_notes
      elsif next_action == options[3]
        delete_notes
        select_action_movies_with_notes
      elsif next_action == options[4]
        scrape_and_print_movies
        select_next_action
      else
        close_app
      end
    end
  end

  def close_app
    puts "\nOk #{self.class.user.username}, hope you enjoyed your time with me!"
    exit!
  end
end
