
----CREATE DATABASE 
----CREATE TABLE

CREATE TABLE sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM sales;
--CLEANING PHASE
--CHECKING FOR NULL  OR MISSING VALUES

SELECT * FROM sales
WHERE 
sale_date IS NULL
OR
customer_id IS NULL
OR
price_per_unit IS NULL
OR
total_sale IS NULL;

--CHECKING FOR DUPLICATES

SELECT transactions_id, count(*) AS duplicate_count FROM sales
GROUP BY transactions_id
HAVING COUNT(*)>1;

--INVALID VALUES

SELECT * FROM sales WHERE quantity<=0
OR price_per_unit <=0
OR age<10 OR age>100;

--CONSISTENCY
SELECT * FROM sales WHERE
total_sale <>quantity*price_per_unit;

--CATEGORY VALIDITY
SELECT DISTINCT category FROM sales
GROUP BY category;

SELECT DISTINCT gender FROM sales
GROUP BY gender;


SELECT * FROM sales
WHERE 
age IS NULL;


SELECT * FROM sales
WHERE age<18;


-------KPIs---
--1. TOTAL REVENUE (SALES)
SELECT SUM(total_sale) AS TOTAL_REVENUE FROM sales;

--2. TOTAL TRANSACTIONS
SELECT COUNT(DISTINCT transactions_id) AS TOTAL_TRANSACTIONS FROM sales;

--3. AVERAGE ORDER VALUE
SELECT ROUND(SUM(total_sale)::NUMERIC/COUNT(DISTINCT transactions_id), 2) AS AVG_ORDER_VALUE FROM sales;

--4.UNITS SOLD
SELECT sum(quantity) AS UNITS_SOLD FROM sales;

--5.TOTAL PROFIT
SELECT ROUND(SUM(total_sale-cogs)::NUMERIC,2) AS TOTAL_PROFIT FROM sales;

--6. PROFIT MARGIN%

SELECT 
     ROUND(
	        (SUM(total_sale-cogs)*100/SUM(total_sale))::NUMERIC, 2) 
      AS PROFIT_MARGIN_PERCENTAGE 
FROM sales;



--7.SALES BY GENDER
SELECT gender, SUM(total_sale) AS SALES FROM sales
GROUP BY gender;

--8. SALES BY AGE GROUP

SELECT 
     CASE 
	    WHEN age BETWEEN 18 AND 25 THEN '18-25'
		WHEN age BETWEEN 26 AND 35 THEN '26-35'
	    WHEN age BETWEEN 36 AND 45 THEN '36-45'
	    WHEN age BETWEEN 46 AND 55 THEN '46-55'
	    WHEN age BETWEEN 56 AND 65 THEN '56-65'
	    WHEN age > 65 THEN '65+'
	    ELSE 'Unknown'
	 END AS age_group, SUM(total_sale) AS SALES 
FROM sales
GROUP BY
        CASE
		   WHEN age BETWEEN 18 AND 25 THEN '18-25'
		   WHEN age BETWEEN 26 AND 35 THEN '26-35'
		   WHEN age BETWEEN 36 AND 45 THEN '36-45'
		   WHEN age BETWEEN 46 AND 55 THEN '46-55'
		   WHEN age BETWEEN 56 AND 65 THEN '56-65'
		   WHEN age > 65 THEN '65+'
		   ELSE 'Unknown'
	     END
ORDER BY SALES DESC;

---9. TOP 10 CUSTOMERS BY SPEND
SELECT customer_id, SUM(total_sale) AS TOTAL_SPENT
FROM sales
GROUP BY customer_id
ORDER BY TOTAL_SPENT DESC
LIMIT 10;
		
---10. REVENUE BY CATEGORY
SELECT category, SUM(total_sale) AS REVENUE
FROM sales
GROUP BY category
ORDER BY category DESC;

--11.profit by category
SELECT category, ROUND(SUM(total_sale-cogs)::NUMERIC,2) AS PROFIT
FROM sales
GROUP BY category
ORDER BY category DESC;

--12.DAILY SALES TREND
SELECT sale_date, SUM(total_sale) AS DAILY_SALES
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

--13. MONTHLY SALES TREND(MONTH NAME FORMAT)
SELECT 
    TO_CHAR(sale_date, 'YYYY') AS YEAR,
	TO_CHAR(sale_date, 'Month') AS MONTH,
	SUM(total_sale) AS MONTHLY_SALES 
FROM sales
GROUP BY 1,2
ORDER BY 1,2;

--14. PEAK HOURS OF SALES (AM/PM FORMAT)
 SELECT
      TO_CHAR(sale_time, 'HH12 AM') AS sale_hour,
	  SUM(total_sale) AS SALE
 FROM sales
 GROUP BY 1
 ORDER BY sale_hour;


	
