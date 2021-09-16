WorldTopMovies::User.delete_all
WorldTopMovies::FavouriteMovie.delete_all

50.times do
  u1 = WorldTopMovies::User.create(username: Faker::Name.unique.name)

  m1 = WorldTopMovies::FavouriteMovie.create(title: Faker::DcComics.title)

# binding.pry
  u1.favourite_movies << m1
end