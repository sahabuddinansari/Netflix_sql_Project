--  Netflix project
-- create table


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type    VARCHAR(10),
	title    VARCHAR(150),
	director  VARCHAR(210),
	caste    VARCHAR(10000),
	countery  VARCHAR(160),
	date_added VARCHAR(50),
	realease_year INT,
	rating  VARCHAR(10),
	duration  VARCHAR(15),
	listed_in VARCHAR(250),
	description  VARCHAR(250)
	)

SELECT *  FROM netflix;

SELECT DISTINCT type
FROM netflix;

SELECT  COUNT(*) as total_content
FROM netflix;


 --  1cont the number of movies and  TV shows


SELECT type, COUNT(*) as total_content
FROM netflix
GROUP BY type


-- 2 find the most common rating and and tv shows

SELECT type, 
rating,
COUNT(*)
FROM netflix
GROUP BY 1,2
ORDER BY 1, 3 DESC


-- higest rating of the tv show and movies

SELECT
	type,
	rating
FROM
(
SELECT type ,
rating,
COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY  1,2
) as t1

WHERE
 ranking = 1


-- 3.List all movies release in a specific year (e.g.2020)


SELECT * FROM netflix
WHERE
 type = 'Movie'
	AND
 	realease_year = 2020



-- 4 Find the top 5  countery with the most content on netflix


SELECT 
UNNEST(STRING_TO_ARRAY(countery, ',')) as new_countery, 
COUNT(show_id) as total_content
FROM netflix                     -- this is distnict function
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT UNNEST(STRING_TO_ARRAY(countery, ',')) as new_countery
FROM netflix;


-- 5.Identify the longest Movies

SELECT * FROM netflix
WHERE
type = 'Movie'
AND 
duration = (SELECT MAX(duration)FROM netflix)


-- 6. find content added in the leat 5 year

SELECT  * FROM netflix
WHERE 
	date_added = CURRENT_DATE - INTERVAL '5 years'


-- 7. find the dirctor name 'rajive chilaka'

SELECT * FROM  netflix
WHERE director LIKE  '%Rajiv Chilaka%'


-- 8.LIST ll tv shows with more than 5 season

SELECT
 * FROM netflix

 WHERE
  	type = 'TV Show'
		AND 
		SPLIT_PART(duration, ' ' ,1)::numeric > 5 


-- 9. conunt the number of contern items in each genre


SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
	 FROM netflix
	 GROUP BY 1



-- 10.India top 




SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) as year,
	 COUNT(*)
	 FROM netflix
	 WHERE countery = 'India'
	 GROUP BY 1


-- 11.list  all movies that are documentaries

	SELECT  * FROM netflix
	WHERE
	 listed_in ILIKE '%documentaries%'


	-- 12.Find all content without a director

	SELECT * FROM netflix
	WHERE
	 director IS NULL



-- 13. find how many movies actor 'salman khan' appeared in last 10 year


SELECT * FROM netflix
WHERE 
caste ILIKE '%Salman Khan%'
AND
realease_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14.find the top 10 actors who have appeared in the higest number p fmovie produce in india


	SELECT 
	UNNEST(STRING_TO_ARRAY(caste, ',')) as actors,
	COUNT(*) as total_content
	FROM netflix
	WHERE countery ILIKE '%india%'
	 GROUP BY 1
	 ORDER BY 2 DESC
	 LIMIT 10


	 -- 15. categorize the  contentj on the presence of th keyword 'kill' and 'violence' in the 
	 -- description field lable content contaninf these keyword as "bad" and all oter are "good "
	 -- count maney item dalll into each category

	WITH new_table
	AS
	(
	 SELECT *,
	 CASE WHEN 
	 		description ILIKE '%kill%' OR
		  description ILIKE '%violence%' THEN 'Bad_content'
		  ELSE 'Good_content'
		  END category
	      FROM netflix
		  )
		  SELECT category,
		  COUNT(*) as total_content
		  FROM new_table
		  GROUP BY 1

	 
	 WHERE
	  description ILIKE '%KILL%'
	  OR
	  description ILIKE '%violence%'
	  






