-- Select all customers from the Dim_Customer table
SELECT * FROM Dim_Customer;

-- Count the total number of products in the Dim_Product table
SELECT COUNT(*) AS TotalProducts FROM Dim_Product;

-- Find all purchases made by a specific customer (CustomerID = 23) in the Fact_Purchases table
SELECT * FROM Fact_Purchases WHERE CustomerID = 23;

-- Get details of all products with a price greater than $10 from the Dim_Product table
SELECT * FROM Dim_Product WHERE Price > 10;

-- Retrieve names and addresses of all customers from New York in the Dim_Customer table
SELECT FirstName, LastName, Address 
FROM Dim_Customer WHERE City = 'New York';

-- List all products that are out of stock (assuming you use Dim_StockLocation to track stock)
SELECT p.Name, sl.StorageLocation 
FROM Dim_Product p
JOIN Dim_StockLocation sl ON p.ProductID = sl.ProductID
WHERE sl.StorageLocation IS NULL;

-- Join Fact_Purchases and Fact_PurchaseDetails to get detailed information about purchases
SELECT fp.PurchaseID, fpd.ProductID, fpd.Quantity 
FROM Fact_Purchases fp
JOIN Fact_PurchaseDetails fpd ON fp.PurchaseID = fpd.PurchaseID;

-- Calculate the total sales amount from all purchases in the Fact_Purchases table
SELECT SUM(TotalAmount) AS TotalSales FROM Fact_Purchases;

-- Find all repairs that cost more than $50 in the Dim_Repair table
SELECT * FROM Dim_Repair WHERE Cost > 50;

-- Get the average price of all products in the Dim_Product table
SELECT AVG(Price) AS AveragePrice FROM Dim_Product;

-- List all deliveries scheduled for a specific date (e.g., '2024-10-01') from the Fact_Delivery table
SELECT * FROM Fact_Delivery WHERE DeliveryDate = '2024-10-01';

-- Retrieve all suppliers that supply a specific product category (e.g., 'Bicycles') from the Dim_Product table
SELECT * FROM Dim_Product WHERE Category = 'Bicycles';

-- Count how many repairs have been made for each product (using Fact_PurchaseDetails for quantity sold)
SELECT p.Name, SUM(fpd.Quantity) AS TotalSold
FROM Fact_PurchaseDetails fpd
JOIN Dim_Product p ON fpd.ProductID = p.ProductID
GROUP BY p.ProductID;

-- Find the most expensive product in the Dim_Product table
SELECT * FROM Dim_Product ORDER BY Price DESC LIMIT 1;

-- Get all purchases made within the last 30 days from the Fact_Purchases table
SELECT * FROM Fact_Purchases WHERE PurchaseDate >= NOW() - INTERVAL 30 DAY;

-- Find the total number of each product sold from the Fact_PurchaseDetails table
SELECT ProductID, SUM(Quantity) AS TotalSold 
FROM Fact_PurchaseDetails 
GROUP BY ProductID;

-- List all products that have a stock quantity below 3 items (using Dim_StockLocation to track stock)
SELECT p.Name 
FROM Dim_Product p
JOIN Dim_StockLocation sl ON p.ProductID = sl.ProductID
GROUP BY p.ProductID
HAVING SUM(sl.StorageLocation) < 3;

-- Find the customer with the highest number of purchases in the Fact_Purchases table
SELECT CustomerID, COUNT(*) AS PurchaseCount 
FROM Fact_Purchases 
GROUP BY CustomerID 
ORDER BY PurchaseCount DESC 
LIMIT 1;

-- Get a summary of the number of products in each category from the Dim_Product table
SELECT Category, COUNT(*) AS ProductCount 
FROM Dim_Product 
GROUP BY Category;

-- Retrieve all repairs along with the corresponding customer information from the Dim_Repair and Dim_Customer tables
SELECT r.*, c.FirstName, c.LastName 
FROM Dim_Repair r
JOIN Dim_Customer c ON r.CustomerID = c.CustomerID;
