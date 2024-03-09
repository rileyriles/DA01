---- Question 1: Clean the data
DO $$
DECLARE
    column_names TEXT[];
    current_column_name TEXT;
BEGIN
    column_names := ARRAY['productline', 'customername', 'contactfullname', 'dealsize', 'territory', 'country', 'state', 'city', 'postalcode', 'addresslline1', 'addressline2'];
    FOREACH current_column_name IN ARRAY column_names
    LOOP
        EXECUTE format('
            ALTER TABLE sales_dataset_rfm_prj
            ALTER COLUMN %I TYPE TEXT USING %I::TEXT',
            current_column_name, current_column_name);
    END LOOP;
END $$;

DO $$
DECLARE
    column_names TEXT[];
    current_column_name TEXT;
BEGIN
    column_names := ARRAY['ordernumber', 'quantityordered', 'orderlinenumber', 'msrp', 'phone', 'postalcode'];
    FOREACH current_column_name IN ARRAY column_names
    LOOP
        BEGIN
            EXECUTE format('
                ALTER TABLE sales_dataset_rfm_prj
                ALTER COLUMN %I TYPE INTEGER USING %I::INTEGER',
                current_column_name, current_column_name);
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Column % is not able to be converted to INTEGER', current_column_name;
        END;
    END LOOP;
END $$;

DO $$
DECLARE
    column_names TEXT[];
    current_column_name TEXT;
BEGIN
    column_names := ARRAY['priceeach','sale'];
    FOREACH current_column_name IN ARRAY column_names
    LOOP
        BEGIN
            EXECUTE format('
                ALTER TABLE sales_dataset_rfm_prj
                ALTER COLUMN %I TYPE NUMERIC USING %I::NUMERIC',
                current_column_name, current_column_name);
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Column % is not able to be converted to NUMERIC', current_column_name;
        END;
    END LOOP;
END $$;

UPDATE sales_dataset_rfm_prj
SET Contactfullname = REPLACE(INITCAP(contactfullname), '-', ' ');

UPDATE sales_dataset_rfm_prj
SET new_timestamp_column = to_timestamp(orderdate, 'MM/DD/YYYY');
ALTER TABLE sales_dataset_rfm_prj DROP COLUMN orderdate;
ALTER TABLE sales_dataset_rfm_prj RENAME COLUMN new_timestamp_column TO orderdate;

---- Question 2: 
SELECT *
FROM sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL OR
    SALES IS NULL;

---- Question 3: 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(100),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(100);

UPDATE sales_dataset_rfm_prj
SET
  CONTACTLASTNAME = SUBSTRING(CONTACTFULLNAME FROM 1 FOR POSITION(' ' IN CONTACTFULLNAME) - 1),
  CONTACTFIRSTNAME = SUBSTRING(CONTACTFULLNAME FROM POSITION(' ' IN CONTACTFULLNAME) + 1);

---- Question 4: 
ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER;

UPDATE sales_dataset_rfm_prj
SET
  QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
  MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
  YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

---- Question 5: 
WITH stats AS (
    SELECT
        AVG(QUANTITYORDERED) AS mean_quantity,
        STDDEV(QUANTITYORDERED) AS stddev_quantity
    FROM sales_dataset_rfm_prj),
z_scores AS (
    SELECT *,
        (QUANTITYORDERED - mean_quantity) / stddev_quantity AS z_score
    FROM sales_dataset_rfm_prj
    CROSS JOIN stats)
SELECT *
FROM z_scores
WHERE abs(z_score) > 3;

WITH quartiles AS (
    SELECT
        percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS Q1,
        percentile_cont(0.5) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS Q2,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS Q3
    FROM sales_dataset_rfm_prj),
iqr AS (
    SELECT
        Q1,
        Q3,
        Q3 - Q1 AS iqr
    FROM quartiles)
SELECT *,
    CASE 
        WHEN QUANTITYORDERED < iqr.Q1 - 1.5 * iqr.iqr OR QUANTITYORDERED > iqr.Q3 + 1.5 * iqr.iqr THEN 'Outlier'
        ELSE 'Not Outlier'
    END AS is_outlier
FROM sales_dataset_rfm_prj, iqr, quartiles;

---- Question 6: 

CREATE TABLE SALES_DATASET_RFM_PRJ_CLEA AS
SELECT *
FROM SALES_DATASET_RFM_PRJ; -- Replace SALES_DATASET_RFM_PRJ with the name of your cleaned table


