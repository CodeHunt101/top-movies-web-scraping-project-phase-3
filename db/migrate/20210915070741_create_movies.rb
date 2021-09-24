class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :duration
      t.string :genres
      t.float :user_rating
      t.integer :metascore
      t.text :description
      t.string :director
      t.string :stars
      t.integer :votes
      t.string :gross_revenue
      t.string :url

      t.timestamps
    end
  end
end
