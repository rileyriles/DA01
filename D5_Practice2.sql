--- Excercise 1
Select distinct city from station
where id % 2 = 0

--- Excercise 2
select 
(count(city)-count(distinct city))
from station

--- Excercise 3
----- *note: Query: Replace: thay thế giá trị 
SELECT 
CEIL((AVG(salary)-AVG(replace(salary,0,''))))
FROM EMPLOYEES

--- Excercise 4
SELECT
ROUND(sum(item_count::DECIMAL * order_occurrences)/sum(order_occurrences),1)
FROM items_per_order

--- Excercise 5
SELECT candidate_id FROM candidates
WHERE skill in ('Python','Tableu','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id ASC;

--- Excercise 6
SELECT user_id, 
MAX(post_date::DATE) - MIN(post_date::DATE)
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021 
GROUP BY user_id
HAVING COUNT(post_id)>1;

--- Excercise 7
SELECT card_name,
MAX(issued_amount) - min(issued_amount)
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY card_name DESC;

--- Excercise 8
SELECT
manufacturer, 
COUNT (drug),
ABS (SUM(total_sales - cogs)) as total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <=0
GROUP BY manufacturer
ORDER BY SUM(total_sales - cogs) asc;

--- Excercise 9
SELECT * FROM cinema
WHERE MOD(id,2) <> 0
AND description not in ('boring')
ORDER BY rating DESC

--- Excercise 10
SELECT teacher_id,
COUNT(DISTINCT subject_id) as cnt
FROM teacher
GROUP BY teacher_id

--- Excercise 11
SELECT user_id,
COUNT(follower_id) as followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC

--- Excercise 12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) > 5

