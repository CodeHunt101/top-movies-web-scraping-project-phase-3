SELECT favourite_movies.title FROM favourite_movies
INNER JOIN user_movies
ON user_movies.favourite_movie_id = favourite_movies.id;
WHERE user_movies.user_id = 1;