WorldTopMovies::DB::User.destroy_all
WorldTopMovies::DB::UserMovie.destroy_all
WorldTopMovies::DB::Movie.destroy_all
WorldTopMovies::DB::Note.destroy_all
WorldTopMovies::DB::UserNote.destroy_all


u1 = WorldTopMovies::DB::User.create(username: Faker::Name.unique.name)
u2 = WorldTopMovies::DB::User.create(username: Faker::Name.unique.name)
m1 = WorldTopMovies::DB::Movie.create(title: Faker::DcComics.title)
n1 = WorldTopMovies::DB::Note.create(note_message: "hegwfdiybgwefiyehbwfibfewifgbweifb", movie_id: m1.id)
n2 = WorldTopMovies::DB::Note.create(note_message: "acbderfghijklmnopq", movie_id: m1.id)

u1.notes << n1
# u2.notes << n1
u2.notes << n2