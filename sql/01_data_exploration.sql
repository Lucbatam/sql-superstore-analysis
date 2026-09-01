-- 00. Preview Raw Data
SELECT
    *
FROM
    superstore_raw
LIMIT
    20;

-- 01. Total number of rows
SELECT
    COUNT(*) AS total_rows
FROM
    superstore_raw;

-- 02. Number of distinct orders
SELECT
    COUNT(DISTINCT "Order ID") AS total_orders
FROM
    superstore_raw;

-- 03. Number of distinct customers
SELECT
    COUNT(DISTINCT "Customer ID") AS total_customers
FROM
    superstore_raw;

-- 04. Number of distinct products
SELECT
    COUNT(DISTINCT "Product ID") AS total_products
FROM
    superstore_raw;

-- 05. Distinct Product Categories
SELECT DISTINCT
    "Category"
FROM
    superstore_raw
ORDER BY
    "Category";

-- 06. Top 10 Orders by Total Sales
SELECT
    "Order ID",
    "Customer ID",
    ROUND(SUM(Sales), 2) AS Total_Sales_Order
FROM
    superstore_raw
GROUP BY
    "Order ID",
    "Customer ID"
ORDER BY
    "Total_Sales_Order" DESC
LIMIT
    10;

-- 07a. Sales of Technology Category
SELECT
    *
FROM
    superstore_raw
WHERE
    Category = 'Technology'
LIMIT
    20;

-- 07b. Total Sales of Technology Category
SELECT
    ROUND(SUM(Sales), 2) AS Total_Sales_Technology
FROM
    superstore_raw
WHERE
    Category = 'Technology';

-- 08. Total Sales by Category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM
    superstore_raw
GROUP BY
    Category
ORDER BY
    Total_Sales DESC;

-- 09. Sales and Profit by Category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM
    superstore_raw
GROUP BY
    Category
ORDER BY
    Total_Profit DESC;

-- 10. Average Profit by Category
SELECT
    Category,
    ROUND(AVG(Profit), 2) AS Average_Profit
FROM
    superstore_raw
GROUP BY
    Category
ORDER BY
    Average_Profit DESC;

-- 11. Orders by Cateogry
SELECT
    Category,
    COUNT(DISTINCT ("Order ID")) AS "Total_Orders"
FROM
    superstore_raw
GROUP BY
    Category
ORDER BY
    "Total_Orders" DESC;