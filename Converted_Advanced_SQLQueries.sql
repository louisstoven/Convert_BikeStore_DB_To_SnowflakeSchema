-- Retrieve each customer's total spending, including their name and email, sorted by highest spending
SELECT c.FirstName, c.LastName, c.Email, SUM(p.TotalAmount) AS TotalSpent
FROM Dim_Customer c
JOIN Fact_Purchases p ON c.CustomerID = p.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- Find the top 3 most popular products based on the total quantity sold
SELECT fpd.ProductID, p.Name, SUM(fpd.Quantity) AS TotalQuantitySold
FROM Fact_PurchaseDetails fpd
JOIN Dim_Product p ON fpd.ProductID = p.ProductID
GROUP BY fpd.ProductID
ORDER BY TotalQuantitySold DESC
LIMIT 3;

-- Calculate the percentage of products in each category that are low on stock (defined as below 10 units)
-- Assuming stock quantities are derived from the Dim_StockLocation
SELECT p.Category, 
       COUNT(*) AS TotalProducts,
       SUM(CASE WHEN (SELECT SUM(QuantitySupplied) FROM Fact_Supplies fs WHERE fs.ProductID = p.ProductID) < 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LowStockPercentage
FROM Dim_Product p
GROUP BY p.Category;

-- Find all customers who have made a purchase within the last 6 months and list the number of purchases they made
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(p.PurchaseID) AS PurchaseCount
FROM Dim_Customer c
JOIN Fact_Purchases p ON c.CustomerID = p.CustomerID
WHERE p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.CustomerID
HAVING PurchaseCount > 1
ORDER BY PurchaseCount DESC;

-- List products that have been sold more than their current stock quantity
-- Here we're summing quantities sold and comparing against total supplied from Fact_Supplies
SELECT p.ProductID, p.Name, 
       (SELECT SUM(QuantitySupplied) FROM Fact_Supplies fs WHERE fs.ProductID = p.ProductID) AS CurrentStock,
       SUM(fpd.Quantity) AS QuantitySold
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
GROUP BY p.ProductID
HAVING QuantitySold > (SELECT SUM(QuantitySupplied) FROM Fact_Supplies fs WHERE fs.ProductID = p.ProductID);

-- Retrieve the total revenue generated per product category
SELECT p.Category, SUM(pur.TotalAmount) AS TotalRevenue
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
JOIN Fact_Purchases pur ON fpd.PurchaseID = pur.PurchaseID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- Calculate the average delivery time in days for each customer
SELECT c.CustomerID, c.FirstName, c.LastName, 
       AVG(DATEDIFF(d.DeliveryDate, p.PurchaseDate)) AS AvgDeliveryDays
FROM Fact_Delivery d
JOIN Fact_Purchases p ON d.PurchaseID = p.PurchaseID
JOIN Dim_Customer c ON p.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY AvgDeliveryDays;

-- Find the month with the highest sales revenue in the past year
SELECT MONTHNAME(p.PurchaseDate) AS Month, SUM(p.TotalAmount) AS MonthlyRevenue
FROM Fact_Purchases p
WHERE p.PurchaseDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY Month
ORDER BY MonthlyRevenue DESC
LIMIT 1;

-- List each supplier's top-selling product and the total sales amount for that product
SELECT s.SupplierID, s.Name AS SupplierName, 
       p.Name AS TopProduct, 
       SUM(fpd.Quantity * fpd.UnitPrice) AS TotalSales
FROM Dim_Supplier s
JOIN Fact_Supplies sp ON s.SupplierID = sp.SupplierID
JOIN Dim_Product p ON sp.ProductID = p.ProductID
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
GROUP BY s.SupplierID, p.ProductID
ORDER BY s.SupplierID, TotalSales DESC;

-- Identify customers who have purchased both mountain bikes and road bikes
SELECT c.CustomerID, c.FirstName, c.LastName
FROM Dim_Customer c
JOIN Fact_Purchases p ON c.CustomerID = p.CustomerID
JOIN Fact_PurchaseDetails fpd ON p.PurchaseID = fpd.PurchaseID
JOIN Dim_Product pr ON fpd.ProductID = pr.ProductID
WHERE pr.Name IN ('Mountain Bike', 'Road Bike')
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(DISTINCT pr.Name) = 2;

-- List all products with their stock quantity, sales quantity, and the difference between the two
SELECT p.ProductID, 
       p.Name, 
       COALESCE(SUM(fs.QuantitySupplied), 0) AS StockQuantity, -- Stock derived from Fact_Supplies
       COALESCE(SUM(fpd.Quantity), 0) AS TotalSold, 
       (COALESCE(SUM(fs.QuantitySupplied), 0) - COALESCE(SUM(fpd.Quantity), 0)) AS StockDifference
FROM Dim_Product p
LEFT JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
LEFT JOIN Fact_Supplies fs ON p.ProductID = fs.ProductID
GROUP BY p.ProductID, p.Name;

-- Find the total amount spent by customers who have made repairs on their products
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(p.TotalAmount) AS TotalSpent
FROM Dim_Customer c
JOIN Fact_Purchases p ON c.CustomerID = p.CustomerID
WHERE c.CustomerID IN (SELECT DISTINCT CustomerID FROM Dim_Repair)
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- Get each product’s minimum, average, and maximum sale quantity across all purchases
SELECT p.ProductID, p.Name,
       MIN(fpd.Quantity) AS MinQuantitySold,
       AVG(fpd.Quantity) AS AvgQuantitySold,
       MAX(fpd.Quantity) AS MaxQuantitySold
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
GROUP BY p.ProductID, p.Name;

-- Retrieve the number of repairs needed per year for each product category
SELECT p.Category, YEAR(r.RepairDate) AS RepairYear, COUNT(r.RepairID) AS RepairCount
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
JOIN Fact_Purchases pur ON fpd.PurchaseID = pur.PurchaseID
JOIN Dim_Repair r ON pur.CustomerID = r.CustomerID
GROUP BY p.Category, RepairYear
ORDER BY RepairYear DESC;

-- Determine the percentage of revenue generated by each product in its category
SELECT p.Category, p.Name, 
       SUM(fpd.Quantity * fpd.UnitPrice) AS ProductRevenue,
       SUM(fpd.Quantity * fpd.UnitPrice) * 100.0 / SUM(SUM(fpd.Quantity * fpd.UnitPrice)) OVER (PARTITION BY p.Category) AS RevenuePercentage
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
GROUP BY p.Category, p.Name
ORDER BY p.Category, RevenuePercentage DESC;

-- Find the top 3 states by customer count and the total purchases made by customers in those states
SELECT c.State, COUNT(c.CustomerID) AS CustomerCount, SUM(p.TotalAmount) AS TotalPurchases
FROM Dim_Customer c
JOIN Fact_Purchases p ON c.CustomerID = p.CustomerID
GROUP BY c.State
ORDER BY CustomerCount DESC
LIMIT 3;

-- Retrieve each product's stock and the average number of units sold per sale, ordered by highest average units sold
SELECT p.ProductID, p.Name, 
       COALESCE(SUM(fs.QuantitySupplied), 0) AS StockQuantity, 
       AVG(fpd.Quantity) AS AvgUnitsPerSale
FROM Dim_Product p
LEFT JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
LEFT JOIN Fact_Supplies fs ON p.ProductID = fs.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY AvgUnitsPerSale DESC;

-- Calculate the total sales revenue per product and display products where revenue exceeds $1,000
SELECT p.ProductID, p.Name, SUM(fpd.Quantity * fpd.UnitPrice) AS TotalRevenue
FROM Dim_Product p
JOIN Fact_PurchaseDetails fpd ON p.ProductID = fpd.ProductID
GROUP BY p.ProductID
HAVING TotalRevenue > 1000
ORDER BY TotalRevenue DESC;
