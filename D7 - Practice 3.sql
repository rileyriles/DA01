---- Excercise 1
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT (name,3), ID ASC

---- Exercise 2
SELECT user_id, 
CONCAT(upper(left(name,1)),lower(substring(name,2))) as name
FROM Users 
ORDER BY user_id

---- Exercise 3
SELECT manufacturer,
'$'|| ROUND (SUM (total_sales)/1000000) || ' ' || 'million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC

---- Excercise 4
SELECT
EXTRACT(month from submit_date),
product_id,
ROUND(AVG(stars),2)
FROM reviews
GROUP BY EXTRACT(month from submit_date), product_id
ORDER BY EXTRACT(month from submit_date), product_id

---- Excercise 5
SELECT
sender_id,
COUNT (content)
FROM messages
WHERE EXTRACT(month from sent_date) = '8' 
AND EXTRACT(year from sent_date) = '2022'
GROUP BY sender_id
ORDER BY count(content) DESC
LIMIT 2

---- Excercise 6
Select
tweet_id
from Tweets
WHERE length (content) > 15

---- Excercise 7
select activity_date as day, count(distinct(user_id)) as active_users from Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
group by activity_date;

---- Excercise 8
select count(id) 
from employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-08-01'

---- Excercise 9
select 
POSITION ('a' in first_name)
from worker
WHERE first_name = 'Amitah'

---- Excercise 10
select CONCAT (substring(title,length(winery)+2,4), substring (title from length(winery)+6 for position (' (Tikves)' in title)))
from winemag_p2
WHERE country = 'Macedonia'
