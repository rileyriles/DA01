---- Excercise 1
WITH spending_amount AS (SELECT
  EXTRACT (YEAR from transaction_date) AS year_of_transaction,
  product_id,
  spend as current_year_spending,
  LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id,
  EXTRACT (Year from transaction_date)) as previous_year_spending
FROM user_transactions)

SELECT year_of_transaction,
  product_id,
  current_year_spending,
  previous_year_spending,
  ROUND ( 100 * 
    (current_year_spending - previous_year_spending)/ 
    previous_year_spending, 2) as growth_rate
FROM spending_amount

---- Excercise 2
WITH issue_amount AS (
  SELECT *,
    RANK () OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) as ranking
  FROM monthly_cards_issued)

SELECT card_name, issued_amount 
FROM issue_amount
WHERE ranking = 1
ORDER BY issued_amount desc;

---- Excercise 3
WITH transaction_ranking AS (
  SELECT *,
    ROW_NUMBER () OVER (PARTITION BY user_id ORDER BY transaction_date DESC) as ranking
  FROM transactions)
  
SELECT user_id, spend, transaction_date
FROM transaction_ranking
WHERE ranking = 3

---- Excercise 4
WITH max_transaction AS (SELECT transaction_date, user_id, product_id,
  RANK () OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS ranking
FROM user_transactions) 

SELECT transaction_date, user_id,
  COUNT (product_id) AS purchase_count
FROM max_transaction
WHERE ranking = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date

---- Excercise 5
WITH final_rank as (
  SELECT a.artist_name,
    DENSE_RANK() OVER (ORDER BY COUNT (b.song_id) DESC) as artist_rank
  FROM artists as a  
  JOIN songs as b ON a.artist_id = b.artist_id
  JOIN global_song_rank as c ON b.song_id = c.song_id
  WHERE c.rank <= 10
  GROUP BY a.artist_name)
  
SELECT artist_name, artist_rank
FROM final_rank
WHERE artist_rank <=5

---- Excercise 6
WITH payments AS (SELECT transaction_id, 
  merchant_id, 
  credit_card_id,
  amount,
  transaction_timestamp,
  EXTRACT (EPOCH FROM transaction_timestamp - 
    LAG(transaction_timestamp) 
      OVER (PARTITION BY merchant_id, credit_card_id, amount
        ORDER BY transaction_timestamp))
        / 60 as different
  FROM transactions)

SELECT COUNT(merchant_id) AS payment_count
FROM payments
WHERE different <= 10
  
---- Excercise 7
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

---- Excercise 8
SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) 
  OVER (PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets
