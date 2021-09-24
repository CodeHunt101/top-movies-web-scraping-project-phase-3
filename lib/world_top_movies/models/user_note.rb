class WorldTopMovies::DB::UserNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :note

  def self.delete_note_record_from_user(user:, note_id:)
    self.joins(:user, :note)
      .where("notes.id" => note_id, "users.username" => user.username).destroy_all
  end
end
