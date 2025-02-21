

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


SELECT *
FROM netflix;

SELECT 
	COUNT(*) AS total_content
FROM netflix;


-- 1. Count the Number of Movies vs TV Shows
SELECT 
	type AS movies_and_tvshows,
	COUNT(*) AS count_of_movies_and_tvshows
FROM netflix
GROUP BY type

-- 2. Find the Most Common Rating for Movies and TV Shows
SELECT
	type, 
	rating
FROM
(SELECT 
	type,
	rating,
	COUNT(rating) AS rating_count,
	RANK() OVER(PARTITION BY type ORDER BY COUNT(rating) DESC) as RN
FROM netflix
GROUP BY type, rating
ORDER BY type, COUNT(rating) DESC) AS ranked_ratings
WHERE rn = 1


-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT
	type,
	title
FROM netflix
WHERE release_year = 2020
AND type = 'Movie'

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS count_of_content
FROM netflix
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 5. Identify the Longest Movie
SELECT 
	title
FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix)

-- 6. Find content added in the last 5 years
SELECT 
	*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YY') >= CURRENT_DATE - INTERVAL '5 YEARS'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT
	type,
	title
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'
ORDER BY type

-- 8. List all TV shows with more than 5 seasons
SELECT 
	type,
	title, 
	duration
FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration,' ', 1)::numeric > 5

-- 9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genres,
	COUNT(1) AS total_count
FROM netflix
GROUP BY 1


-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(1)::numeric/(SELECT COUNT(1) FROM netflix WHERE country = 'India') * 100 AS average_count
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC


-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries';


-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT 
	*
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS casts,
	COUNT(1) AS count_movies
FROM netflix
WHERE country = 'India'
AND type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT *
FROM netflix
WHERE description ILIKE '%kill%'
OR description ILIKE '%violence%'












