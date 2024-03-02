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

