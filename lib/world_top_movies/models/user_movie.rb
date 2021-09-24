class WorldTopMovies::DB::UserMovie < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie

  def self.delete_movie_record_from_user(user:, movie_url:)
    self.joins(:user, :movie)
      .where("movies.url" => movie_url, "users.username" => user.username).destroy_all
  end
end
