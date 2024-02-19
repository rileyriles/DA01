---Excercise 1
SELECT name FROM city
WHERE COUNTRYCODE = 'USA'
AND population > 120000

---Excercise 2
SELECT * from CITY
WHERE COUNTRYCODE = 'JPN'

---Excercise 3
SELECT city, state FROM STATION

---Excercise 4
SELECT DISTINCT city FROM STATION
WHERE city like 'a%' 
OR city like 'e%' 
OR city like 'i%' 
OR city like 'o%'
OR city like 'u%'

---Excercise 5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u'

---Excercise 6
SELECT DISTINCT city FROM STATION
WHERE city not like 'a%' 
and city not like 'e%' 
and city not like 'i%' 
and city not like 'o%'
and city not like 'u%'

---Excercise 7
SELECT name FROM Employee
ORDER BY name ASC

---Excercise 8
SELECT name FROM Employee
WHERE salary >2000
AND months <10
ORDER BY employee_id ASC

---Excercise 9
# Write your MySQL query statement below
SELECT product_id FROM Products
WHERE low_fats = 'Y'
AND recyclable = 'Y'

---Excercise 10
# Write your MySQL query statement below
SELECT name FROM Customer
WHERE referee_id <> 2 
OR referee_id is null

---Excercise 11
SELECT name, population, area FROM World
WHERE area >= 3000000
OR population >= 25000000

---Excercise 12
SELECT DISTINCT author_id as "id" FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC

---Excercise 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date is NULL

---Excercise 14
select * from lyft_drivers
where yearly_salary <= 30000
or yearly_salary >= 70000

---Excercise 15
select advertising_channel from uber_advertising
where money_spent > 100000
and year = 2019
