class WorldTopMovies::DB::Note < ActiveRecord::Base
  has_one :user_note, dependent: :destroy
  has_one :user, through: :user_note
  belongs_to :movie

  def self.create_note(movie_url:, note_message:, user:)
    #Creates a note to a movie that is created if it's not in the database, and appends it to the user
    attributes = WorldTopMovies::DB::Movie.generate_attributes_from_url(movie_url)
    if !WorldTopMovies::DB::Movie.find_by(url: movie_url)
      movie_record = WorldTopMovies::DB::Movie.create(attributes)
    else
      movie_record = WorldTopMovies::DB::Movie.find_by(url: movie_url)
    end
    note_record = self.create(note_message: note_message, movie_id: movie_record.id)
    user.notes << note_record
  end

  def self.delete_note_instance_from_user(user:, note_id:)
    user.notes.delete(user.find_note_from_id(note_id))
  end
end
