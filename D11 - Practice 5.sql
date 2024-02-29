---- EXCERCISE 1
SELECT a.continent, FLOOR(AVG(b.population))
FROM country as a
INNER JOIN city as b
ON a.code = b.countrycode
GROUP BY a.continent;

---- EXCERCISE 2
SELECT 
  ROUND(COUNT(table2.email_id)::DECIMAL 
  /COUNT(DISTINCT table1.email_id),2) AS activation_rate
FROM emails as table1
LEFT JOIN texts as table2
ON table1.email_id = table2.email_id
AND table2.signup_action in ('Confirmed')

---- EXCERCISE 3
SELECT b.age_bucket,
  ROUND( 100 * SUM(a.time_spent) FILTER (WHERE a.activity_type = 'send')/
      SUM(a.time_spent),2) as send_perc,
  ROUND( 100 * SUM(a.time_spent) FILTER (WHERE a.activity_type = 'open')/
      SUM(a.time_spent),2) as open_perc
FROM activities as a
LEFT JOIN age_breakdown as b
ON a.user_id = b.user_id
WHERE a.activity_type in ('send','open')
GROUP BY b.age_bucket

---- EXCERCISE 4
WITH Supercloud as (SELECT a.customer_id, COUNT(DISTINCT b.product_category)
FROM customer_contracts as a
LEFT JOIN products as b
ON a.product_id=b.product_id
GROUP BY a.customer_id) 

SELECT customer_id
FROM supercloud
WHERE count = (
  SELECT COUNT(DISTINCT product_category) 
  FROM products)
ORDER BY customer_id;

---- EXCERCISE 5
SELECT a.employee_id, name, reports_count, average_age
FROM (
    SELECT reports_to AS employee_id, count(distinct employee_id) AS reports_count,
    ROUND(AVG(age)) AS average_age
    FROM Employees
    GROUP BY reports_to
    HAVING reports_to is not null
    ) AS a
LEFT JOIN Employees AS b
ON a.employee_id = b.employee_id
ORDER BY a.employee_id;

---- EXCERCISE 6
SELECT a.product_name, SUM(b.unit) as unit
FROM products as a
LEFT JOIN Orders as b
ON a.product_id=b.product_id
WHERE b.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY a.product_name
HAVING SUM(b.unit) >=100;

---- EXCERCISE 7
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b
ON a.page_id=b.page_id
WHERE b.liked_date is null
ORDER BY a.page_id ASC 
