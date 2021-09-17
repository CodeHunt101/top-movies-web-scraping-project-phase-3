SELECT users.username, movies.title 
FROM movies
INNER JOIN user_movies
ON user_movies.movie_id = movies.id
INNER JOIN users
ON user_movies.user_id = users.id;





SELECT user_movies.* 
FROM user_movies 
INNER JOIN users
ON users.id = user_movies.user_id
INNER JOIN movies
ON movies.id = user_movies.movie_id
WHERE movies.url = "https://imdb.com/title/tt0050083/" AND users.username = "harold"
LIMIT 11;



SELECT "user_movies".* 
FROM "user_movies" 
INNER JOIN "users" 
ON "users"."id" = "user_movies"."user_id" 
INNER JOIN "movies" 
ON "movies"."id" = "user_movies"."favourite_movie_id" 
WHERE "movies"."title" = "Inception" 
LIMIT 11;