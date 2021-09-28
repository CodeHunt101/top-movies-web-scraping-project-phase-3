class WorldTopMovies::DB::User < ActiveRecord::Base
  has_many :user_movies, dependent: :destroy
  has_many :movies, through: :user_movies
  has_many :user_notes, dependent: :destroy
  has_many :notes, through: :user_notes

  def print_all_favourite_movie_titles
    puts "\nOk! Your favourite movies are:\n\n"
    sleep(1.5)
    self.movies.sort_by { |m| m.title }.each_with_index do |m, i|
      sleep(0.01)
      WorldTopMovies::Movie.print_movie_compact(m, i)
    end
  end

  def favourite_movie_titles
    # Returns a hash with key=title, value=url of all fav movies
    result = {}
    self.movies.sort_by { |m| m.title }.each { |m| result[m.title] = m.url }
    result
  end

  def find_movie_from_url(movie_url)
    self.movies.find { |m| m.url == movie_url }
  end

  def print_movies_with_notes
    puts "\nOk! Your movies with notes are:\n\n"
    sleep(1.5)
    self.movies_with_notes_arr.sort_by { |m| m.title }.each_with_index do |m, i|
      sleep(0.01)
      WorldTopMovies::Movie.print_movie_compact(m, i)
    end
  end

  def movies_with_notes_titles
    result = {}
    self.movies_with_notes_arr.sort_by { |m| m.title }.each { |m| result[m.title] = m.url }
    result
  end

  def movies_with_notes_arr
    self.notes.map { |note| note.movie }.uniq
  end

  def print_all_notes
    puts "\nPrinting #{self.notes.count} note(s):\n\n"
    sleep(1.5)
    self.notes.each_with_index do |n, i|
      sleep(0.01)
      puts "--------------------------------------------------------------"
      puts "\n#{i + 1}. #{n.note_message.colorize(:color => :green).italic}, \
Movie: #{n.movie.title.colorize(:color => :light_blue).bold}, \
Date: #{n.created_at.localtime.to_s.colorize(:color => :red).bold} \n"
    end
  end

  def notes_titles
    result = {}
    self.notes.each { |n| result["#{n.note_message}, #{n.movie.title}, #{n.created_at.localtime.to_s}"] = n.id }
    result
  end

  def find_note_from_id(note_id)
    self.notes.find { |n| n.id == note_id }
  end
end
