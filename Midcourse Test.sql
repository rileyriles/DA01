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

---- QUESTION 6
SELECT COUNT(a.address_id) FILTER(WHERE b.address_id is null)
FROM address as a
LEFT JOIN customer as b
ON a.address_id=b.address_id

---- QUESTION 7
SELECT a.city, SUM(d.amount)
FROM city as a
INNER JOIN address as b ON a.city_id=b.city_id
INNER JOIN customer as c ON b.address_id = c.address_id
INNER JOIN payment as d ON c.customer_id=d.customer_id
GROUP BY a.city
ORDER BY SUM(d.amount) DESC

---- QUESTION 8
SELECT a.country || ',' || ' ' || b.city as Country_and_City, SUM(e.amount) as total_amount
FROM country as a
INNER JOIN city as b ON a.country_id=b.country_id
INNER JOIN address as c ON b.city_id=c.city_id
INNER JOIN customer as d ON c.address_id = d.address_id
INNER JOIN payment as e ON d.customer_id=e.customer_id
GROUP BY a.country || ',' || ' ' || b.city
ORDER BY SUM(e.amount) DESC

--- NOTE: Question 8 input answer từ đề bài có sai không? Bởi vì đề hỏi doanh thu cao nhất, tức United States, Cape Coral với 221.55 amount. Còn United States, Tallahassee should be nhỏ nhất, với 50.85 total_amount

