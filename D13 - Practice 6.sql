---- Excericise 1
WITH job_count_table as (
  SELECT company_id, title, description, 
   COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description)

SELECT COUNT(DISTINCT company_id) AS duplicated_companies
FROM job_count_table
WHERE job_count > 1; 

---- Excercise 2
---- *Note: Hàm Patition By: dùng để goup theo nhóm như Group By nhưng không gộp lại một dòng
WITH total_spend_products AS (
SELECT category, product, sum(spend) as totalspend,
  ROW_NUMBER () 
    OVER (
      PARTITION BY category 
      ORDER BY sum(spend) DESC) 
      AS ranking
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product)

SELECT category, product, totalspend
FROM total_spend_products
WHERE ranking <= 2

---- Excercise 3
WITH call_record AS (
SELECT
  policy_holder_id,
  COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3)

SELECT COUNT(policy_holder_id) AS member_count
FROM call_record

---- Excercise 4
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b
ON a.page_id=b.page_id
WHERE b.liked_date is null
ORDER BY a.page_id ASC 

---- Excercise 5
SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);

---- Excercise 6 
SELECT Date_format(trans_date, '%Y-%m') AS month, 
       country, 
       Count(id) AS trans_count, 
       Count(IF(state = 'approved', 1, NULL)) AS approved_count, 
       SUM(amount) AS trans_total_amount, 
       SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount 
FROM   transactions 
GROUP  BY Date_format(trans_date, '%Y-%m'), 
          country 
ORDER BY NULL

---- Excercise 7
SELECT a.product_id,
    MIN(year) as first_year, 
    a.quantity, a.price
FROM sales as a
LEFT JOIN product as b
ON a.product_id=b.product_id
GROUP BY a.product_id;

---- Excercise 8
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = 
    (SELECT
       COUNT(DISTINCT product_key) AS totl_product
    FROM product) 

---- Excercise 9
SELECT employee_id
FROM employees
WHERE salary <= 30000
AND manager_id not in (
    select employee_id from Employees)

---- Excercise 10
* Note: Mình nghĩ là Excercise 10 đang nhảy link với Excercise 1, hay là do account của mình?

---- Excercise 11
SELECT user_name AS results FROM
(
SELECT a.name AS user_name, COUNT(*) AS counts FROM MovieRating AS b
    JOIN Users AS a
    on a.user_id = b.user_id
    GROUP BY b.user_id
    ORDER BY counts DESC, user_name ASC LIMIT 1
) firstquery
UNION
SELECT movie_name AS results FROM
(
SELECT c.title AS movie_name, AVG(d.rating) AS rate FROM MovieRating AS d
    JOIN Movies AS c
    on c.movie_id = d.movie_id
    WHERE substr(d.created_at, 1, 7) = '2020-02'
    GROUP BY d.movie_id
    ORDER BY rate DESC, movie_name ASC LIMIT 1
) secondquery

---- Excercise 12
WITH
    accept_list AS (
        SELECT requester_id, accepter_id FROM RequestAccepted
        UNION
        SELECT accepter_id, requester_id FROM RequestAccepted
    )
SELECT requester_id AS id, COUNT(accepter_id) AS num
FROM accept_list
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


