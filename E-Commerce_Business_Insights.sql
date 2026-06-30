-- Database creation
CREATE DATABASE ECommerce_Analytics;
USE ECommerce_Analytics;

--  off Safe Update Mode 
SET SQL_SAFE_UPDATES = 0;

DELETE FROM fact_orders 
WHERE Product_ID NOT IN (SELECT Product_ID FROM dim_products);

--  on Safe Update Mode 
SET SQL_SAFE_UPDATES = 1;

-- firstly set datatype of product_ID as VARCHAR in dim_products 
ALTER TABLE dim_products MODIFY COLUMN Product_ID VARCHAR(50) NOT NULL;

-- Formation of primary key
ALTER TABLE dim_products ADD PRIMARY KEY (Product_ID);

--  set columns data type as VARCHAR in fact_orders table 
ALTER TABLE fact_orders MODIFY COLUMN OrderID VARCHAR(50) NOT NULL;
ALTER TABLE fact_orders MODIFY COLUMN Product_ID VARCHAR(50) NOT NULL;

-- Assign foreign kry and primary key
ALTER TABLE fact_orders ADD PRIMARY KEY (OrderID);
ALTER TABLE fact_orders ADD CONSTRAINT fk_product FOREIGN KEY (Product_ID) REFERENCES dim_products(Product_ID);

-- Total Revenue
SELECT 
    SUM(f.Quantity * p.Price_Cleaned) AS Total_Revenue,
    SUM(f.Quantity) AS Total_Products_Sold,
    COUNT(DISTINCT f.OrderID) AS Total_Orders
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID;

-- Top 5 Highest Selling Products by Revenue
SELECT 
    p.Product_Name,
    SUM(f.Quantity) AS Total_Qty,
    SUM(f.Quantity * p.Price_Cleaned) AS Total_Revenue
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC;
LIMIT 5;

-- Customer Spending Behavior & Total Orders (CTE)
WITH CustomerSales AS (
    SELECT 
        f.CustomerID,
        COUNT(f.OrderID) AS Total_Orders,
        SUM(f.Quantity * p.Price_Cleaned) AS Total_Spent
    FROM fact_orders f
    JOIN dim_products p ON f.Product_ID = p.Product_ID
    GROUP BY f.CustomerID
)
SELECT * FROM CustomerSales
ORDER BY Total_Spent DESC;

--  Top 5 premium customer (highest spender)
SELECT 
    f.CustomerID,
    COUNT(f.OrderID) AS Total_Orders,
    SUM(f.Quantity * p.Price_Cleaned) AS Total_Spent
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
GROUP BY f.CustomerID
ORDER BY Total_Spent DESC
LIMIT 5;

--  Rating-wise Best Performing Product (Window Function)
WITH RatedSales AS (
    SELECT 
        p.Rating_Numeric,
        p.Product_Name,
        SUM(f.Quantity * p.Price_Cleaned) AS Product_Revenue,
        DENSE_RANK() OVER (PARTITION BY p.Rating_Numeric ORDER BY SUM(f.Quantity * p.Price_Cleaned) DESC) AS Revenue_Rank
    FROM fact_orders f
    JOIN dim_products p ON f.Product_ID = p.Product_ID
    GROUP BY p.Rating_Numeric, p.Product_Name
)
SELECT Rating_Numeric, Product_Name, Product_Revenue
FROM RatedSales
WHERE Revenue_Rank = 1;

--  Customer Segmentation (CASE Statement)
SELECT 
    f.CustomerID,
    SUM(f.Quantity * p.Price_Cleaned) AS Total_Spent,
    CASE 
        WHEN SUM(f.Quantity * p.Price_Cleaned) >= 150 THEN 'Premium Customer'
        WHEN SUM(f.Quantity * p.Price_Cleaned) BETWEEN 50 AND 149.99 THEN 'Regular Customer'
        ELSE 'Budget Customer'
    END AS Customer_Segment
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
GROUP BY f.CustomerID
ORDER BY Total_Spent DESC;

--  Price Range-wise Performance (Data Binning)
SELECT 
    CASE 
        WHEN p.Price_Cleaned < 20 THEN 'Under £20 (Low Price)'
        WHEN p.Price_Cleaned BETWEEN 20 AND 40 THEN '£20 - £40 (Mid Price)'
        ELSE 'Above £40 (Premium Price)'
    END AS Price_Range,
    COUNT(DISTINCT f.OrderID) AS Total_Orders,
    SUM(f.Quantity) AS Total_Qty_Sold,
    SUM(f.Quantity * p.Price_Cleaned) AS Total_Revenue
FROM fact_orders f
JOIN dim_products p ON f.Product_ID = p.Product_ID
GROUP BY 
    CASE 
        WHEN p.Price_Cleaned < 20 THEN 'Under £20 (Low Price)'
        WHEN p.Price_Cleaned BETWEEN 20 AND 40 THEN '£20 - £40 (Mid Price)'
        ELSE 'Above £40 (Premium Price)'
    END
ORDER BY Total_Revenue DESC;

--  Unsold Stock Analysis (Dead Inventory)
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Price_Cleaned
FROM dim_products p
LEFT JOIN fact_orders f ON p.Product_ID = f.Product_ID
WHERE f.Product_ID IS NULL;