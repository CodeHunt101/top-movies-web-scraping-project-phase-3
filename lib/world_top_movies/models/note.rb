class WorldTopMovies::DB::Note < ActiveRecord::Base
  has_one :user_note, dependent: :destroy
  has_one :user, through: :user_note
  belongs_to :movie
end