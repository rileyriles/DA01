---- Ad-hoc 1: 
SELECT
  EXTRACT(YEAR FROM o.created_at) AS year,
  EXTRACT(MONTH FROM o.created_at) AS month,
  COUNT(DISTINCT o.user_id) AS total_buyers,
  COUNT(*) AS completed_orders
FROM
  bigquery-public-data.thelook_ecommerce.orders AS o
WHERE
  o.created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
  AND o.status = 'Shipped'
GROUP BY
  year, month
ORDER BY
  year, month;

---- Ad-hoc2: 
WITH MonthlyOrderStats AS (
  SELECT
    DATE_TRUNC(o.created_at, MONTH) AS month_year,
    COUNT(DISTINCT o.user_id) AS distinct_users,
    SUM(oi.sale_price) AS total_order_value,
    COUNT(*) AS total_orders
  FROM
    bigquery-public-data.thelook_ecommerce.orders AS o
  JOIN
    bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON
    o.order_id = oi.order_id
  WHERE
    o.created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
    AND o.status = 'Shipped'
  GROUP BY
    month_year
)

SELECT
  FORMAT_DATE('%Y-%m', month_year) AS month_year,
  distinct_users,
  total_order_value / total_orders AS average_order_value
FROM
  MonthlyOrderStats
ORDER BY
  month_year;

