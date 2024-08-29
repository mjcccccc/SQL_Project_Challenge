   /*
	PROJECT 1: RETAIL SALES ANALYSIS USING MS SQL
*/
/*
		DATABASE SETUP
*/
DROP DATABASE IF EXISTS Retail_SalesDB;
CREATE DATABASE Retail_SalesDB;
USE Retail_SalesDB;

-- Create table
DROP TABLE IF EXISTS Retail_SalesDB.dbo.retail_sales;
CREATE TABLE retail_sales(
	transaction_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time VARCHAR(255),
	customer_id	INT,
	gender VARCHAR(255),
	age	INT,
	category VARCHAR(255),	
	quantity	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale INT
)

-- Alter the Data type of sale_time to TIME
ALTER TABLE retail_sales
ALTER COLUMN sale_time TIME;

/*
		DATA CLEANING
*/

SELECT TOP 10 * 
FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales;

-- Select all the row that is NULL
SELECT * FROM retail_sales
WHERE transaction_id IS NULL OR sale_date IS NULL
	OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL OR quantity	IS NULL
	OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

-- Delete rows that have NULL value
DELETE FROM retail_sales
WHERE transaction_id IS NULL OR sale_date IS NULL 
	OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL OR quantity	IS NULL
	OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

-/* 
		DATA EXPLORATION
*/

-- How many sales we have?
SELECT COUNT(*) AS total_sale --Identifying the total count of record we have
FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer 
from retail_sales;

-- What are the categories we have?
SELECT DISTINCT category
FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND quantity >= 4
	AND YEAR(sale_date) = 2022 AND MONTH(sale_date) = 11;

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
	DISTINCT category,
	SUM(total_sale) OVER(PARTITION BY category) AS net_sale
FROM retail_sales
ORDER BY net_sale DESC;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = LOWER('beauty');

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
	category,
	gender,
	COUNT(*) AS total_no
FROM retail_sales
GROUP BY category, gender;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH best_selling_month AS(
	SELECT
		YEAR(sale_date) AS year,
		FORMAT(sale_date,'MMMM') AS month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY FORMAT(sale_date,'MMMM'), YEAR(sale_date)
)

SELECT
	year,
	month,
	avg_sales
FROM best_selling_month
WHERE rank = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT	
	TOP 5
	customer_id,
	SUM(total_sale) AS total_spend
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spend DESC;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT
	COUNT(DISTINCT customer_id) AS count_customer,
	category
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH period_of_day_sale AS(
	SELECT *,
		CASE WHEN DATEPART(HOUR, sale_time) > 17 THEN 'Evening'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Morning' 
		END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM period_of_day_sale
GROUP BY shift;