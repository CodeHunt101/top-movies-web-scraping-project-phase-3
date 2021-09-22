class WorldTopMovies::DB::Note < ActiveRecord::Base
  has_one :user_note
  has_one :user, through: :user_note
end