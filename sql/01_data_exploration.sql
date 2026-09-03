-- database: ../database/superstore.db
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

-- From now on, we created another table from the original superstore_raw
-- The new table superstore now contains integer and real numbers for the
-- following columns: Row ID, Postal Code, Sales, Quantity, Discount, Profit

-- 12. Profit or Loss
SELECT
    "Order ID",
    "Profit",
    CASE
    WHEN "Profit" > 0 THEN 'Profit'
    WHEN "Profit" < 0 THEN 'Loss'
    ELSE 'Break-even'
    END AS "Profit-Loss"
FROM
    superstore
LIMIT 20;

-- 13. Quantity of Profit / Loss / Break-even
WITH profit_loss_cte AS (
    SELECT *,
    CASE
    WHEN "Profit" > 0 THEN 'Profit'
    WHEN "Profit" < 0 THEN 'Loss'
    ELSE 'Break-even'
    END AS "Profit-Loss"
    FROM
    superstore  )

SELECT "Profit-Loss", COUNT("Profit-Loss") AS "Count-profit-loss"
FROM profit_loss_cte
GROUP BY "Profit-Loss";

-- 14. Total Profit | Total Loss | Net Profit
SELECT 
    SUM(
        CASE
            WHEN "Profit" > 0 THEN "Profit"
            ELSE 0
            END
            ) AS "Total Profit",
    SUM(
        CASE
            WHEN "Profit" < 0 THEN "Profit" * -1
            ELSE 0
            END
            ) AS "Total Loss",
    SUM("Profit")  AS "Net Profit"

FROM superstore;

-- 15. Profit Margin
SELECT
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore;

-- 16. Profit Margin by Category
SELECT
    "Category",
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "Category"
ORDER BY "Profit Margin (%)" DESC;

-- 17. Profit Margin by Sub-Category
SELECT
    "Sub-Category",
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "Sub-Category"
ORDER BY "Profit Margin (%)" DESC;

-- 18. Sales Volume and Profitability by Sub-Category
SELECT
    "Sub-Category",
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)',
    SUM("Quantity") AS 'Total Quantity'
FROM superstore
GROUP BY "Sub-Category"
ORDER BY "Total Sales" DESC;

-- 19. Discount Impact in Profit Margin
SELECT
    "Discount",
    COUNT(*) AS 'Count',
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "Discount"
ORDER BY "Discount";

-- 20. Sales and Profit by Year
SELECT
    substr("Order Date",-4) AS 'Year',
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "Year"
ORDER BY "Year";

-- 21. Sales YoY
WITH my_cte AS (
    SELECT
        substr("Order Date",-4) AS 'Year',
        SUM("Sales") AS 'Total Sales'
    FROM superstore
    GROUP BY "Year"
)

SELECT
    *,
    ROUND(("Total Sales" - 
    LAG("Total Sales") OVER (ORDER BY "Year")) / 
    LAG("Total Sales") OVER (ORDER BY "Year")* 100,2)
    AS 'Sales YoY (%)'
FROM my_cte
ORDER BY "Year";

-- 22. Ranking of Products by Sales
SELECT
    "Product Name",
    ROUND(SUM(Sales),2) AS 'Total Sales',
    SUM("Quantity") AS 'Total Quantity'
FROM superstore
GROUP BY "Product Name"
ORDER BY "Total Sales" DESC
LIMIT 10;

-- 23. Ranking of Products by Profit
SELECT
    "Product Name",
    ROUND(SUM(Profit),2) AS 'Net Profit',
    ROUND(SUM("Sales"),2) AS 'Total Sales'
FROM superstore
GROUP BY "Product Name"
ORDER BY "Net Profit" DESC
LIMIT 10;

-- 24. Customer Analysis
SELECT
    "Customer Name",
    COUNT(DISTINCT "Order ID") AS 'Total Orders',
    ROUND(SUM(Profit),2) AS 'Net Profit',
    ROUND(SUM("Sales"),2) AS 'Total Sales'
FROM superstore
GROUP BY "Customer Name"
ORDER BY "Net Profit" DESC
LIMIT 10;

-- 25. Region Analysis
SELECT
    "Region",
    COUNT(DISTINCT "Order ID") AS 'Total Orders',
    ROUND(SUM(Profit),2) AS 'Net Profit',
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "Region"
ORDER BY "Net Profit" DESC;

-- 26. State Analysis
SELECT
    "State",
    COUNT(DISTINCT "Order ID") AS 'Total Orders',
    ROUND(SUM(Profit),2) AS 'Net Profit',
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND((SUM("Profit") / SUM("Sales")) * 100,2) AS 'Profit Margin (%)'
FROM superstore
GROUP BY "State"
ORDER BY "Net Profit" DESC
LIMIT 10;

-- 27a. Ranking Net Profit States by Region
SELECT
    "State",
    ROUND(SUM(Profit),2) AS 'Net Profit',
    RANK() OVER(
        PARTITION BY "Region"
        ORDER BY SUM(Profit) DESC) AS 'Rank'
FROM superstore
ORDER BY "Region", "Rank";

-- 27b. Top #3 States by Region
WITH state_profit AS (
    SELECT
        "Region",
        "State",
        ROUND(SUM("Profit"), 2) AS "Net Profit"
    FROM superstore
    GROUP BY "Region", "State"
)
,
rank_cte AS (
    SELECT
        "Region",
        "State",
        "Net Profit",
        RANK() OVER (
            PARTITION BY "Region"
            ORDER BY "Net Profit" DESC
        ) AS "Rank"
    FROM state_profit
)
SELECT
    "Region",
    "State",
    "Net Profit",
    "Rank"
FROM rank_cte
WHERE "Rank" <= 3;

-- 28. Sales Share by Category
SELECT
    "Category",
    ROUND(SUM("Sales"), 2) AS "Total Sales",
    ROUND(
        (SUM("Sales") / (SELECT SUM("Sales") FROM superstore)) * 100,2
    ) AS "Sales Share (%)"
FROM superstore
GROUP BY "Category";

-- 29. Returning Customers
SELECT
    "Customer Name",
    COUNT(DISTINCT("Order ID")) AS 'Total Orders',
    ROUND(SUM("Sales"),2) AS 'Total Sales',
    ROUND(SUM("Profit"),2) AS 'Net Profit'
FROM superstore
GROUP BY "Customer Name"
HAVING "Total Orders" >= 2
ORDER BY "Total Orders" DESC


