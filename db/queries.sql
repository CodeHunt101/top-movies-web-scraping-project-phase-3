SELECT users.username, movies.title 
FROM movies
INNER JOIN user_movies
ON user_movies.movie_id = movies.id
INNER JOIN users
ON user_movies.user_id = users.id;