class WorldTopMovies::DB::UserMovie < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
end