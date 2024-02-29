---- QUESTION 1
SELECT MIN(DISTINCT replacement_cost) 
FROM film;

---- QUESTION 2
SELECT
	SUM (CASE
		  WHEN replacement_cost between 9.99 and 19.99 THEN 1
		ELSE 0
		END) as low_cost,
	SUM (CASE
		  WHEN replacement_cost between 20.00 and 24.99 THEN 1
		ELSE 0
		END) as medium_cost,
	SUM (CASE
		  WHEN replacement_cost between 25.00 and 29.99 THEN 1
		ELSE 0
		END) as high_cost
FROM film;

---- QUESTION 3
SELECT a.title, a.length, c.name
FROM film as a
INNER JOIN film_category as b ON a.film_id = b.film_id
INNER JOIN category as c ON b.category_id = c.category_id
WHERE c.name in ('Drama','Sports')
ORDER BY a.length DESC

---- QUESTION 4
SELECT DISTINCT c.name, COUNT(a.title)
FROM film as a
INNER JOIN film_category as b ON a.film_id = b.film_id
INNER JOIN category as c ON b.category_id = c.category_id
WHERE c.name in ('Drama','Sports')
GROUP BY DISTINCT c.name

---- QUESTION 5
SELECT a.first_name, a.last_name, COUNT(b.film_id)
FROM actor as a
INNER JOIN film_actor as b ON a.actor_id=b.actor_id
INNER JOIN film as c ON b.film_id=c.film_id
GROUP BY a.first_name, a.last_name
ORDER BY COUNT(b.film_id) DESC


