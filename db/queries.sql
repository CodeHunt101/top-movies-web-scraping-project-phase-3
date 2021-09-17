SELECT users.username, favourite_movies.title 
FROM favourite_movies
INNER JOIN user_movies
ON user_movies.favourite_movie_id = favourite_movies.id
INNER JOIN users
ON user_movies.user_id = users.id;





SELECT user_movies.* 
FROM user_movies 
INNER JOIN users
ON users.id = user_movies.user_id
INNER JOIN favourite_movies
ON favourite_movies.id = user_movies.favourite_movie_id
WHERE favourite_movies.url = "https://imdb.com/title/tt0050083/" AND users.username = "harold"
LIMIT 11;



SELECT "user_movies".* 
FROM "user_movies" 
INNER JOIN "users" 
ON "users"."id" = "user_movies"."user_id" 
INNER JOIN "favourite_movies" 
ON "favourite_movies"."id" = "user_movies"."favourite_movie_id" 
WHERE "favourite_movies"."title" = "Inception" 
LIMIT 11;