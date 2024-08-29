# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Tool**: MS SQL Server, Microsoft SQL Server Management Studio (SSMS)  
**Database**: `Retail_SalesDB`

This project challenge aims to improve and showcase my SQL skills and data analysis techniques through the retail sales dataset. This project is one of the simple real-world projects that involves database setup, data cleaning, exploratory data analysis (EDA), and answering specific business questions using SQL queries. By completing this project, I hope to create a foundation for making informed business decisions based on the insights gained from the retail sales data.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_SalesDB`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

<details open>
<summary>Click to expand!</summary>

```sql
DROP DATABASE IF EXISTS Retail_SalesDB;
CREATE DATABASE Retail_SalesDB;
USE Retail_SalesDB;

-- Create table
DROP TABLE IF EXISTS Retail_SalesDB.dbo.retail_sales;
CREATE TABLE retail_sales(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time VARCHAR(255),
    customer_id INT,
    gender VARCHAR(255),
    age INT,
    category VARCHAR(255),    
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale INT
)

-- Alter the Data type of sale_time to TIME
ALTER TABLE retail_sales
ALTER COLUMN sale_time TIME;
```
</details> 

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

<details open>
<summary>Click to expand!</summary>

```sql

-- How many sales do we have?
SELECT COUNT(*) AS total_sale --Identifying the total count of record we have
FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer 
from retail_sales;

-- What are the categories we have?
SELECT DISTINCT category
FROM retail_sales;

-- Select all the values that are NULL
SELECT * FROM retail_sales
WHERE transaction_id IS NULL OR sale_date IS NULL
	OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL OR quantity	IS NULL
	OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

-- Delete records with missing data
DELETE FROM retail_sales
WHERE transaction_id IS NULL OR sale_date IS NULL 
	OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL
	OR age IS NULL OR category IS NULL OR quantity	IS NULL
	OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
 ```
</details>

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
 ```
</details>

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
   
<details open>
<summary>Click to expand!</summary>

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND quantity >= 4
	AND YEAR(sale_date) = 2022 AND MONTH(sale_date) = 11;
 ```
</details>

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT
	DISTINCT category,
	SUM(total_sale) OVER(PARTITION BY category) AS net_sale
FROM retail_sales
ORDER BY net_sale DESC;
 ```
</details>

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = LOWER('beauty');
 ```
</details>

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
 ```
</details>

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT
	category,
	gender,
	COUNT(*) AS total_no
FROM retail_sales
GROUP BY category, gender;
 ```
</details>

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
<details open>
<summary>Click to expand!</summary>

```sql
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
 ```
</details>

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT	
	TOP 5
	customer_id,
	SUM(total_sale) AS total_spend
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spend DESC;
 ```
</details>


9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
<details open>
<summary>Click to expand!</summary>

```sql
SELECT
	COUNT(DISTINCT customer_id) AS count_customer,
	category
FROM retail_sales
GROUP BY category;
 ```
</details>

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
<details open>
<summary>Click to expand!</summary>

```sql
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
 ```
</details>

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project has provided me with a comprehensive learning experience as a data analyst, offering a hands-on introduction to SQL. I explored various aspects of data analysis, including database setup, data cleaning, exploratory data analysis (EDA), and formulating SQL queries to address specific business questions. Through this project, I have developed a solid understanding of how to leverage SQL to gain insights into sales trends, customer preferences, and product performance. The knowledge I gained will enable me to make informed business decisions that drive growth and profitability.
