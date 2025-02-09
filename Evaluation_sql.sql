CREATE DATABASE Evaluation;

USE Evaluation;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT,
    Price DECIMAL(10, 2),
    OrderDate DATETIME,
    Category VARCHAR(255)
);



INSERT INTO Orders (OrderID, CustomerName, Product, Quantity, Price, OrderDate, Category) VALUES
(101, 'Customer_1', 'Product_A', 10, 20, '2023-01-01 00:00:00', 'Electronics'),
(102, 'Customer_2', 'Product_B', 5, 35, '2023-01-02 00:00:00', 'Furniture'),
(103, 'Customer_3', 'Product_C', 15, 50, '2023-01-03 00:00:00', 'Clothing'),
(104, 'Customer_4', 'Product_D', 8, 25, '2023-01-04 00:00:00', 'Books'),
(105, 'Customer_5', 'Product_E', 7, 15, '2023-01-05 00:00:00', 'Electronics'),
(106, 'Customer_6', 'Product_A', 12, 30, '2023-01-06 00:00:00', 'Electronics'),
(107, 'Customer_7', 'Product_B', 14, 45, '2023-01-07 00:00:00', 'Furniture'),
(108, 'Customer_8', 'Product_C', 6, 20, '2023-01-08 00:00:00', 'Clothing'),
(109, 'Customer_9', 'Product_D', 9, 40, '2023-01-09 00:00:00', 'Books'),
(110, 'Customer_10', 'Product_E', 10, 25, '2023-01-10 00:00:00', 'Electronics'),
(111, 'Customer_11', 'Product_A', 11, 15, '2023-01-11 00:00:00', 'Electronics'),
(112, 'Customer_12', 'Product_B', 4, 35, '2023-01-12 00:00:00', 'Furniture'),
(113, 'Customer_13', 'Product_C', 8, 30, '2023-01-13 00:00:00', 'Clothing'),
(114, 'Customer_14', 'Product_D', 16, 20, '2023-01-14 00:00:00', 'Books'),
(115, 'Customer_15', 'Product_E', 7, 50, '2023-01-15 00:00:00', 'Electronics'),
(116, 'Customer_16', 'Product_A', 12, 45, '2023-01-16 00:00:00', 'Electronics'),
(117, 'Customer_17', 'Product_B', 5, 25, '2023-01-17 00:00:00', 'Furniture'),
(118, 'Customer_18', 'Product_C', 9, 15, '2023-01-18 00:00:00', 'Clothing'),
(119, 'Customer_19', 'Product_D', 11, 50, '2023-01-19 00:00:00', 'Books'),
(120, 'Customer_20', 'Product_E', 10, 30, '2023-01-20 00:00:00', 'Electronics');

# 1. Select all columns from the table.
SELECT * FROM Orders;



# 2. Find the total revenue (Quantity * Price) for each product and calculate the overall revenue.
SELECT 
    Product,
    SUM(Quantity * Price) AS TotalRevenue
FROM 
    Orders
GROUP BY 
    Product;

-- Overall revenue
SELECT 
    SUM(Quantity * Price) AS OverallRevenue
FROM 
    Orders;
    
    
# 3. Use a CTE to calculate the average price of products by category and 
# then display categories where the average price is greater than 30.    
WITH AveragePrice AS (
    SELECT 
        Category,
        AVG(Price) AS AvgPrice
    FROM 
        Orders
    GROUP BY 
        Category
)
SELECT 
    Category
FROM 
    AveragePrice
WHERE 
    AvgPrice > 30;
    
# 4. Write a query to find the product with the highest price in each category using a window function.

WITH RankedOrders AS (
    SELECT 
        Product,
        Category,
        Price,
        RANK() OVER (PARTITION BY Category ORDER BY Price DESC) AS PriceRank_
    FROM 
        Orders
)
SELECT *
FROM RankedOrders
WHERE 
    PriceRank_ = 1;
    
# 5. Use a JOIN to combine the product table with another table that contains supplier 
# information and display the supplier name along with product details.

-- SELECT 
--     o.OrderID,
--     o.CustomerName,
--     o.Product,
--     o.Quantity,
--     o.Price,
--     o.OrderDate,
--     o.Category,
--     s.SupplierName
-- FROM 
--     Orders o
-- JOIN 
--     Suppliers s ON o.SupplierID = s.SupplierID;

# 6. Write a query to find the top 3 most expensive products using a window function (RANK or DENSE_RANK).

SELECT *
FROM (
    SELECT 
        Product,
        Price,
        DENSE_RANK() OVER (ORDER BY Price DESC) AS PriceRank
    FROM 
        Orders
) AS RankedOrders
WHERE 
    PriceRank <= 3;
  
# 7. Use a GROUP BY query to count the number of products in 
# each category and calculate the total quantity for each category.  

SELECT 
    Category,
    COUNT(Product) AS ProductCount,
    SUM(Quantity) AS TotalQuantity
FROM 
    Orders
GROUP BY 
    Category;
    
 # 8. Write a query to calculate the cumulative revenue for each product using a window function.
 
 SELECT 
    Product,
    Quantity,
    Price,
    SUM(Quantity * Price) OVER (ORDER BY Product) AS CumulativeRevenue
FROM 
    Orders;
    
    

# 9. Use a CTE to display products that have a quantity greater than the average quantity of all products. 

WITH AverageQuantity AS (
    SELECT 
        AVG(Quantity) AS AvgQuantity
    FROM 
        Orders
)
SELECT 
    *
FROM 
    Orders
WHERE 
    Quantity > (SELECT AvgQuantity FROM AverageQuantity);  
    
    
# 10. Update the price of all products in the "Electronics" category by increasing it by 10%.

SET SQL_SAFE_UPDATES = 0;

UPDATE Orders
SET Price = Price * 1.10
WHERE Category = 'Electronics';    