WorldTopMovies::User.destroy_all
WorldTopMovies::FavouriteMovie.destroy_all

u1 = WorldTopMovies::User.create(username: "harold")

m1 = WorldTopMovies::FavouriteMovie.create(title: "terminator")

# binding.pry
u1.favourite_movies << m1