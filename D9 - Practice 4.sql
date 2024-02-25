---- Excercise 1
SELECT
SUM(CASE
    WHEN device_type in ('tablet','phone') THEN 1
    ELSE 0
  END) as mobile_views,
SUM(CASE
    WHEN device_type in ('laptop') THEN 1
    ELSE 0
END) as laptop_views
FROM viewership

---- Excercise 2
SELECT *,
CASE
    WHEN x + y > z AND y + z > x AND z + x > y THEN 'Yes'
    ELSE 'No'
END as triangle
FROM Triangle

---- Excercise 3
  --- *NOTE: Hàm filter: Lọc ô dữ liệu theo tiêu chí.
SELECT
ROUND (100 * COUNT (case_id) FILTER ( WHERE call_category isnull AND call_category = 'n/a') /
COUNT (case_id),1)
AS uncategorised_call_percentage
FROM callers;

---- Excercise 4
SELECT name
FROM Customer
WHERE referee_id isnull 
OR referee_id NOT IN ('2')

---- Excercise 5
select survived,
SUM (CASE
    WHEN pclass = 1 THEN 1
    ELSE 0
    END) as first_class,
SUM (CASE
    WHEN pclass = 2 THEN 1
    ELSE 0
    END) as second_class,
SUM (CASE
    WHEN pclass = 3 THEN 1
    ELSE 0
    END) as third_class
from titanic
group by survived;
