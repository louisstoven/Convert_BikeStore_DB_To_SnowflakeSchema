-- Create Dim_Customer table
CREATE TABLE Dim_Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Dim_Product table
CREATE TABLE Dim_Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Category VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Dim_Supplier table
CREATE TABLE Dim_Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactName VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Dim_Date table
CREATE TABLE Dim_Date (
    DateID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    DayOfWeek INT,
    WeekOfYear INT
);

-- Create Fact_Purchases table
CREATE TABLE Fact_Purchases (
    PurchaseID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    DateID INT NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Dim_Customer(CustomerID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

-- Create Fact_PurchaseDetails table
CREATE TABLE Fact_PurchaseDetails (
    PurchaseDetailID INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PurchaseID) REFERENCES Fact_Purchases(PurchaseID),
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID)
);

-- Create Fact_Delivery table
CREATE TABLE Fact_Delivery (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseID INT NOT NULL,
    DeliveryDate DATE,
    Status VARCHAR(20) NOT NULL,
    TrackingNumber VARCHAR(100),
    DateID INT NOT NULL, 
    FOREIGN KEY (PurchaseID) REFERENCES Fact_Purchases(PurchaseID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

-- Create Fact_Supplies table
CREATE TABLE Fact_Supplies (
    SupplyID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT NOT NULL,
    ProductID INT NOT NULL,
    SupplyDate DATE,
    QuantitySupplied INT NOT NULL,
    DateID INT NOT NULL, 
    FOREIGN KEY (SupplierID) REFERENCES Dim_Supplier(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

-- Create Dim_Repair table
CREATE TABLE Dim_Repair (
    RepairID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RepairDate DATE,
    Description TEXT NOT NULL,
    Cost DECIMAL(10, 2),
    DateID INT NOT NULL, 
    FOREIGN KEY (CustomerID) REFERENCES Dim_Customer(CustomerID),
    FOREIGN KEY (DateID) REFERENCES Dim_Date(DateID)
);

-- Create Dim_StockLocation table
CREATE TABLE Dim_StockLocation (
    StorageID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    StorageLocation VARCHAR(100),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Dim_Product(ProductID)
);