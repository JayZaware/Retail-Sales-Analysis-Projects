CREATE DATABASE superstore_db;
USE superstore_db;
SELECT * FROM superstore LIMIT 10;
SELECT DISTINCT Category FROM superstore;
SELECT COUNT(*) AS total_orders FROM superstore;
SELECT ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS total_sales FROM superstore;
SELECT ROUND(SUM(CAST(Profit AS DECIMAL(10,2))),2) AS total_profit FROM superstore;
SELECT ROUND(AVG(CAST(Sales AS DECIMAL(10,2))),2) AS avg_sales FROM superstore;

-- Sales by Region
SELECT Region,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS regional_sales
FROM superstore
GROUP BY Region
ORDER BY regional_sales DESC;

-- Top 10 Customers
SELECT `Customer Name`,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS total_spent
FROM superstore
GROUP BY `Customer Name`
ORDER BY total_spent DESC
LIMIT 10;

-- Top Selling Products
SELECT `Product Name`,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS total_sales
FROM superstore
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;

-- Profit by Category
SELECT Category,
ROUND(SUM(CAST(Profit AS DECIMAL(10,2))),2) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;

-- Quantity Sold by Category
SELECT Category,
SUM(CAST(Quantity AS SIGNED)) AS total_quantity
FROM superstore
GROUP BY Category
ORDER BY total_quantity DESC;

-- Orders from Each State
SELECT State,
COUNT(*) AS total_orders
FROM superstore
GROUP BY State
ORDER BY total_orders DESC;

-- Loss Making Products
SELECT `Product Name`,
ROUND(SUM(CAST(Profit AS DECIMAL(10,2))),2) AS total_loss
FROM superstore
GROUP BY `Product Name`
HAVING total_loss < 0
ORDER BY total_loss;

-- Monthly Sales Trend
SELECT
MONTH(STR_TO_DATE(`Order Date`, '%Y-%m-%d')) AS month_no,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS monthly_sales
FROM superstore
GROUP BY month_no
ORDER BY month_no;

-- Average Profit per Order
SELECT
ROUND(AVG(CAST(Profit AS DECIMAL(10,2))),2) AS avg_profit
FROM superstore;

-- Highest Discount Products
SELECT `Product Name`,
MAX(CAST(Discount AS DECIMAL(10,2))) AS max_discount
FROM superstore
GROUP BY `Product Name`
ORDER BY max_discount DESC;

-- Region with Highest Profit
SELECT Region,
ROUND(SUM(CAST(Profit AS DECIMAL(10,2))),2) AS regional_profit
FROM superstore
GROUP BY Region
ORDER BY regional_profit DESC
LIMIT 4;

-- Customer Ranking Using Window Function
SELECT
`Customer Name`,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS total_sales,
RANK() OVER (
ORDER BY SUM(CAST(Sales AS DECIMAL(10,2))) DESC
) AS customer_rank
FROM superstore
GROUP BY `Customer Name`;

-- Category Contribution Percentage
SELECT
Category,
ROUND(
SUM(CAST(Sales AS DECIMAL(10,2))) * 100 /
(
SELECT SUM(CAST(Sales AS DECIMAL(10,2)))
FROM superstore
),2
) AS sales_percentage
FROM superstore
GROUP BY Category;

-- Most Profitable Sub-Category
SELECT `Sub-Category`,
ROUND(SUM(CAST(Profit AS DECIMAL(10,2))),2) AS total_profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY total_profit DESC
LIMIT 10;

-- Running Total Sales
SELECT
`Order Date`,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS daily_sales,
ROUND(
SUM(SUM(CAST(Sales AS DECIMAL(10,2))))
OVER (ORDER BY `Order Date`),
2
) AS running_total
FROM superstore
GROUP BY `Order Date`;

-- Customers with Sales Above Average
SELECT `Customer Name`,
ROUND(SUM(CAST(Sales AS DECIMAL(10,2))),2) AS total_sales
FROM superstore
GROUP BY `Customer Name`
HAVING total_sales >
(
SELECT AVG(CAST(Sales AS DECIMAL(10,2)))
FROM superstore
);