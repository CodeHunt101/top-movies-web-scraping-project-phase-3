class WorldTopMovies::CLI
  @@prompt = TTY::Prompt.new
  
  def prompt
    @@prompt
  end
  
  def run
    self.start
    self.scrape_and_generate_movies
    self.print_movies_compact
  end

  def start
    
    artii = Artii::Base.new({})
    puts '-----------------------------------------------------------------------------------'
    puts artii.asciify('World Top Movies!')
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
    name = self.prompt.ask("May I have your name, please?") do |q|
      q.required(true, "Oops, seems you haven't provided your name. Try again please.")
      q.validate(/[a-zA-Z][^0-9]/, "Invalid name, please try again.")
      q.modify   :capitalize
    end
    puts "Thanks #{name}. I'd like to ask you some questions, ok?"
  
  end

  def scrape_and_generate_movies
    
    sleep(1.5)
    type_of_scrape = self.prompt.select(
      "Would you like to see the list of all movies in general or by genre?",
      %w(General Genre))
    puts "Alright! We're going to see the top #{type_of_scrape} movies..."
    
    genre = nil if type_of_scrape == "General"

    type_of_scrape == "Genre" && (
      genre = self.prompt.enum_select(
        "Choose a genre:", WorldTopMovies::Scraper.genres
      )
    )
    WorldTopMovies::Scraper.new(genre).make_movies
    
  end

  def print_movies_compact
    
    WorldTopMovies::Movie.all.each do |m|
      puts "Title: #{m.title}"
    end
  
  end

end