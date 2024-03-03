---- Excercise 1
SELECT 
  ROUND (SUM (CASE WHEN order_date = customer_pref_delivery_date THEN 1 
  Else 0 
  END) * 100.0 / COUNT(delivery_id), 2) as immediate_percentage
FROM delivery
WHERE (customer_id, order_date) in 
    (select customer_id, min(order_date) 
     FROM delivery 
     GROUP BY customer_id)

---- Excercise 2
WITH starting_date AS (
SELECT player_id, min(event_date) as event_start_date
FROM  Activity
GROUP BY player_id )

SELECT
    ROUND((COUNT(DISTINCT a.player_id) / 
    (SELECT COUNT(DISTINCT player_id) FROM activity)),2) as fraction
FROM starting_date as a
JOIN Activity AS b
ON a.player_id = b.player_id
AND datediff(a.event_start_date, b.event_date) = -1

---- Excercise 3
SELECT
    CASE
        WHEN id & 1 = 0 THEN id - 1
        WHEN ROW_NUMBER() OVER (ORDER BY id) != COUNT(id) OVER () THEN id + 1
        ELSE id
    END AS id,
    student
FROM Seat
ORDER BY id

---- Excercise 4
select visited_on, amount, average_amount
from
(select visited_on,
       round(sum(sum(amount)) over(rows between 6 preceding and current row), 2) as amount,
       round(avg(sum(amount)) over(rows between 6 preceding and current row), 2) as average_amount,
       row_number() over() new
from customer
group by visited_on
order by visited_on) new_tb
where new >=7

---- Excercise 5
WITH TIV AS (
  SELECT tiv_2016,
    COUNT(1) OVER (PARTITION BY tiv_2015) AS a,
    COUNT(1) OVER (PARTITION BY lat, lon) AS b
  FROM Insurance)
  
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM TIV
WHERE a > 1 AND b = 1


