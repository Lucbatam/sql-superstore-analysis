-- database: ../database/superstore.db
-- 01.a Create dim_customer table
CREATE TABLE dim_customer (
    "Customer ID" TEXT PRIMARY KEY,
    "Customer Name" TEXT,
    "Segment" TEXT
);

-- 01.b. Inserting values
INSERT INTO dim_customer (
    "Customer ID",
    "Customer Name",
    "Segment"
)
SELECT DISTINCT
    "Customer ID",
    "Customer Name",
    "Segment"
FROM superstore;

-- 01.c Validating Customer Count
SELECT COUNT(*) AS "Total Customers"
FROM dim_customer;

-- 01.d Validating No Duplicated Customers
SELECT
    "Customer ID",
    COUNT(*) AS "Count"
FROM dim_customer
GROUP BY "Customer ID"
HAVING COUNT(*) > 1;

-- 02.a Verified that Some Product ID contains duplicates

SELECT
    "Product ID",
    COUNT(DISTINCT "Product Name") AS "Product Names"
FROM superstore
GROUP BY "Product ID"
HAVING COUNT(DISTINCT "Product Name") > 1;

-- So we can't use Product ID as primary key for dim_product table

-- 02.b. Creating table dim_product
CREATE TABLE dim_product (
    "Product Key" INTEGER PRIMARY KEY,
    "Product ID" TEXT,
    "Product Name" TEXT,
    "Category" TEXT,
    "Sub-Category" TEXT
);

-- 02.c Inserting values
INSERT INTO dim_product (
    "Product Key",
    "Product ID",
    "Product Name",
    "Category",
    "Sub-Category"
)
SELECT
    ROW_NUMBER() OVER (ORDER BY "Product ID", "Product Name"),
    "Product ID",
    "Product Name",
    "Category",
    "Sub-Category"
FROM (
    SELECT DISTINCT
        "Product ID",
        "Product Name",
        "Category",
        "Sub-Category"
    FROM superstore
);

-- 03.a Creating table dim_location
CREATE TABLE dim_location (
    "Postal Code" INTEGER PRIMARY KEY,
    "City" TEXT,
    "State" TEXT,
    "Region" TEXT,
    "Country" TEXT
);

-- 03.b Inserting Values
INSERT INTO dim_location (
    "Postal Code",
    "City",
    "State",
    "Region",
    "Country"
)
SELECT
    "Postal Code",
    MAX("City"),
    MAX("State"),
    MAX("Region"),
    MAX("Country")
FROM superstore
GROUP BY "Postal Code";

-- 04.a Creating dim_date Table
CREATE TABLE dim_date (
    "Date" TEXT PRIMARY KEY,
    "Year" INTEGER,
    "Month" INTEGER,
    "Quarter" INTEGER
);

-- 04.b Inserting Values
INSERT INTO dim_date (
    "Date",
    "Year",
    "Month",
    "Quarter"
)
SELECT DISTINCT
    "Order Date",
    CAST(substr("Order Date", -4) AS INTEGER),
    CAST(substr("Order Date", 1, instr("Order Date", '/') - 1) AS INTEGER),
    ((CAST(substr("Order Date", 1, instr("Order Date", '/') - 1) AS INTEGER) - 1) / 3) + 1
FROM superstore;


-- 05.a Creating table fact_sales
CREATE TABLE fact_sales (
    "Row ID" INTEGER PRIMARY KEY,
    "Order ID" TEXT,
    "Order Date" TEXT,
    "Ship Date" TEXT,
    "Ship Mode" TEXT,
    "Customer ID" TEXT,
    "Product Key" INTEGER,
    "Postal Code" INTEGER,
    "Sales" REAL,
    "Quantity" INTEGER,
    "Discount" REAL,
    "Profit" REAL
);

-- 05.b Inserting Values
INSERT INTO fact_sales (
    "Row ID",
    "Order ID",
    "Order Date",
    "Ship Date",
    "Ship Mode",
    "Customer ID",
    "Product Key",
    "Postal Code",
    "Sales",
    "Quantity",
    "Discount",
    "Profit"
)
SELECT
    s."Row ID",
    s."Order ID",
    s."Order Date",
    s."Ship Date",
    s."Ship Mode",
    s."Customer ID",
    p."Product Key",
    s."Postal Code",
    s."Sales",
    s."Quantity",
    s."Discount",
    s."Profit"
FROM superstore s
JOIN dim_product p
    ON s."Product ID" = p."Product ID"
    AND s."Product Name" = p."Product Name";

SELECT ROUND(SUM("Profit"), 2) AS "Net Profit"
FROM fact_sales;