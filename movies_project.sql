USE moviesdb;

#Selecting certain columns based on the requirement
SELECT title, release_year, studio FROM movies WHERE studio = "marvel studios";


#Finding the number of movies having Avenger in their title
SELECT * FROM movies WHERE title like "%avenger%";


#Herewe want to know which year the movie "The godfather" was released
SELECT release_year FROM movies WHERE title = "the godfather";


#Here we want to print the whole row of the movie name godfather
SELECT * FROM movies WHERE release_year = (SELECT release_year FROM movies WHERE title = "the godfather");


#Here we want to print only those movies of bollywood studio
SELECT * FROM movies WHERE studio IN (SELECT DISTINCT studio FROM movies WHERE industry = "bollywood");


#Here just sorting the movies in descending based on release year
SELECT * FROM movies  ORDER BY release_year DESC;


#Here i want to find the movies, which are released in 2022
SELECT * FROM movies WHERE release_year=2022;


SELECT * FROM movies WHERE release_year like 2022;


#Whatif we want to find the movies having imdb rating greater than 8
SELECT * FROM movies WHERE release_year>2020 and imdb_rating >8;


#Now we want to know all the movies having studio as "Hombale Films" and "marvel studio"
SELECT * FROM movies WHERE studio = "marvel studios" or studio="Hombale Films";


#Find the thor movies in descending order
SELECT * FROM movies WHERE title like "%thor%" ORDER BY release_year DESC;


#Find the movies except the movies from marvel studio
SELECT * FROM movies WHERE studio NOT LIKE "marvel studios";


#Count the number of movies realeased between 2015 and 2022
SELECT COUNT(*) FROM movies WHERE release_year BETWEEN 2015 and 2022;


#Find the min and max relase year 
SELECT 
    min(release_year) as min_years, 
    max(release_year) as max_years 
    FROM movies;


#Count the number of movies as per the release year andn ordered them in ascending order
SELECT release_year,
    COUNT(*) as count_movies
    FROM movies GROUP BY release_year ORDER BY count_movies;


#Here we intend to find the profit earned by the movies
SELECT movie_id, budget, revenue, unit, currency, revenue-budget as profit
    FROM financials ORDER BY profit DESC;


#Here we are find the profit percentage of each movie
SELECT movie_id, budget, revenue, unit, currency, (revenue-budget) as profit, ((revenue-budget)/budget)*100 as Profit_Pct
    FROM financials
    ORDER BY profit DESC;


#Here we are converting the currency from USD to INR
SELECT *, 
    IF (currency="USD", 83*revenue, revenue) 
    FROM financials;


#Converting the units in millions for better comparison
SELECT *, 
    CASE
        WHEN unit="thousands" THEN revenue/1000
        WHEN unit="billions" THEN revenue*1000
        ELSE revenue 
    END as revenue_mlns
    FROM financials ORDER BY revenue_mlns DESC;


#Here, I am joing the movies table with financial table using movie_id
SELECT m.movie_id, title, industry, budget, revenue, unit, currency
    FROM movies m
    JOIN financials f
    ON m.movie_id = f.movie_id;


#Showing few more columns and joing the both table using left join
SELECT m.movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies m
    LEFT JOIN financials f
    ON m.movie_id = f.movie_id;


#Joining the table using right join
SELECT m.movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies m
    RIGHT JOIN financials f
    ON m.movie_id = f.movie_id;


#Joing the table using "USING" keyword
SELECT movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies
    JOIN financials
    USING (movie_id);


#Joing the left joined table and right joined table using 'Union' keyword
SELECT m.movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies m
    LEFT JOIN financials f
    ON m.movie_id = f.movie_id
UNION
SELECT f.movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies m
    RIGHT JOIN financials f
    ON m.movie_id = f.movie_id;


#Performing left outer join using movie id
SELECT movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies
    LEFT OUTER JOIN financials
    USING (movie_id);


#Right outer join using movies id
SELECT movie_id, title, industry, release_year, imdb_rating, budget, revenue, unit, currency
    FROM movies
    RIGHT OUTER JOIN financials
    USING (movie_id);


#Joing movies table with language table using language id
SELECT movie_id, title, industry, release_year, imdb_rating, name
    FROM movies m
    JOIN languages l
    ON m.language_id=l.language_id;


#After joing the table we want to know which movies are released in telugu language
SELECT movie_id, title, industry, release_year, imdb_rating, name
    FROM movies m
    LEFT JOIN languages l
    ON m.language_id=l.language_id
    WHERE l.name="Telugu";


#Now, we want to count the number of movies released in each language
SELECT name, COUNT(title) as Movies
    FROM languages l
    JOIN movies m
    ON l.language_id=m.language_id
    GROUP BY name
    ORDER BY Movies DESC;

#joing the movies table with actors table using actor id
SELECT m.title, a.name
    FROM movies m JOIN movie_actor ma ON m.movie_id=ma.movie_id
        JOIN actors a ON ma.actor_id=a.actor_id;


#Concat the actors who worked in the same movie.
SELECT m.title, GROUP_CONCAT(a.name SEPARATOR " | ") as actors
    FROM movies m 
    JOIN movie_actor ma 
        ON ma.movie_id=m.movie_id
    JOIN actors a 
        ON a.actor_id=ma.actor_id
    GROUP BY m.title;


#Contcat the name of the movies according to the actor, who have acted in it and couting the number of movies
SELECT a.name, GROUP_CONCAT(m.title SEPARATOR " | ") as movies,
    COUNT(m.title) as movie_count
    FROM actors a 
        JOIN movie_actor ma 
            ON ma.actor_id=a.actor_id
        JOIN movies m 
            ON m.movie_id=ma.movie_id
    GROUP BY a.actor_id
ORDER BY movie_count DESC;


#Find the maximum and minimum number of movies released in which year
SELECT release_year, COUNT(*) as movies_count FROM movies WHERE release_year
        in ((SELECT MIN(release_year) FROM movies), (SELECT MAX(release_year) FROM movies))
    GROUP BY release_year
ORDER BY movies_count DESC;


#Finding the movies whose imdb ratings are greater than the average imdb rating
SELECT * FROM movies WHERE imdb_rating>(SELECT AVG(imdb_rating) FROM movies);

#Co-related Query to count the number of movies each actor worked on
SELECT
    actor_id,
    name,
    (SELECT COUNT(*) FROM movie_actor WHERE actor_id=actors.actor_id) as movies_count
FROM actors
ORDER BY movies_count DESC;


#COMMON TABLE EXPRESSION
WITH
    x as (SELECT * FROM movies WHERE release_year>2000),
    y as (SELECT *, (revenue-budget) as profit FROM financials)
SELECT x.movie_id, x.title, x.release_year,
       y.budget, y.revenue, y.profit
    FROM x
    JOIN y
        ON x.movie_id=y.movie_id
    WHERE profit>=500
    ORDER BY profit DESC;

#WITHOUT CTE (using sub-query)
SELECT x.movie_id, x.title, x.release_year,
        y.revenue, y.budget, y.profit
FROM (SELECT * FROM movies WHERE release_year>2000) x
JOIN (SELECT *, (revenue-budget) as profit FROM financials) y
    ON x.movie_id=y.movie_id
    WHERE profit>500
    ORDER BY profit DESC;


#some queries using group by
SELECT COUNT(*) as movies_count FROM movies WHERE release_year BETWEEN 2015 and 2022;

SELECT studio, COUNT(*) as studio_count FROM movies GROUP BY studio ORDER BY studio_count DESC;

SELECT release_year, COUNT(*) as release_year_count FROM movies GROUP BY release_year ORDER BY release_year_count DESC

SELECT industry, COUNT(*) as industry_count FROM movies GROUP BY industry ORDER BY industry_count DESC;


#Finding the number of movies released in each language
SELECT x.language_id, x.language_count, l.name
       FROM languages l
JOIN (SELECT language_id, COUNT(*) as language_count
        FROM movies
        GROUP BY language_id) x
ON l.language_id = x.language_id
ORDER BY language_count DESC;

