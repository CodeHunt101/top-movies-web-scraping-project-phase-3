class CreateFavouriteMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :favourite_movies do |t|
      t.string :title
      t.string :url
      
      t.timestamps
    end
  end
end
