-- Create the database
CREATE DATABASE E_Com_Furniture;

-- Create Categories table
CREATE TABLE Categories (
    CategoryID INT identity(1,1) PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL,
    CategoryDescription TEXT
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT identity(1,1) PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    Description TEXT,
    Dimensions VARCHAR(255),
    Material VARCHAR(255),
    Color VARCHAR(50),
    Weight DECIMAL(10, 2)
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT identity(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(15),
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255),
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT identity(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    ShippingAddress VARCHAR(255) NOT NULL,
    BillingAddress VARCHAR(255) NOT NULL,
    OrderStatus VARCHAR(50) DEFAULT 'Pending',
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Trigger to set OrderDate to the current timestamp
CREATE TRIGGER before_insert_orders
ON Orders
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, ShippingAddress, BillingAddress, OrderStatus, TotalAmount)
    SELECT CustomerID, ISNULL(OrderDate, GETDATE()), ShippingAddress, BillingAddress, OrderStatus, TotalAmount
    FROM inserted;
END;
GO

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT identity(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create Reviews table
CREATE TABLE Reviews (
    ReviewID INT identity(1,1) PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    ReviewText TEXT,
    ReviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create OutOfStockItems table (combining wishlist and wishlist items)
CREATE TABLE OutOfStock (
    OutOfStockID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    OutOfStockDate DATE NOT NULL,
    CONSTRAINT FK_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- Create Payments table
CREATE TABLE Payments (
    PaymentID INT identity(1,1) PRIMARY KEY,
    OrderID INT,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentAmount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50),
    TransactionID VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Sample data for Categories
INSERT INTO Categories (CategoryName, CategoryDescription) VALUES
('Sofas', 'Comfortable seating for living rooms'),
('Tables', 'Dining, coffee, and side tables'),
('Chairs', 'Variety of seating options'),
('Beds', 'Beds of all sizes and styles'),
('Storage', 'Cabinets, dressers, and more');


-- Sample data for Products
INSERT INTO Products (ProductName, CategoryID, Price, Stock, Description, Dimensions, Material, Color, Weight) VALUES
('Modern Sofa', 1, 599.99, 45, 'A stylish modern sofa.', '80x35x30 inches', 'Fabric', 'Gray', 75),
('Dining Table', 2, 299.99, 34, 'A sturdy dining table.', '60x35x30 inches', 'Wood', 'Brown', 50),
('Office Chair', 3, 149.99, 9, 'Ergonomic office chair.', '25x25x45 inches', 'Leather', 'Black', 20),
('Queen Bed', 4, 499.99, 11, 'A queen size bed frame.', '60x80 inches', 'Wood', 'White', 100),
('Storage Cabinet', 5, 199.99, 0, 'Spacious storage cabinet.', '30x15x70 inches', 'Wood', 'Brown', 60),  -- Out of stock
('Recliner Sofa', 1, 799.99, 43, 'A luxurious recliner sofa.', '85x40x35 inches', 'Leather', 'Black', 80),
('Coffee Table', 2, 129.99, 76, 'A modern coffee table.', '40x20x18 inches', 'Glass', 'Clear', 30),
('Bar Stool', 3, 89.99, 0, 'A tall bar stool.', '15x15x30 inches', 'Metal', 'Silver', 15),  -- Out of stock
('Bookshelf', 5, 249.99, 25, 'A large wooden bookshelf.', '35x12x72 inches', 'Wood', 'Oak', 70),
('Lounge Chair', 1, 399.99, 19, 'A comfortable lounge chair.', '35x35x35 inches', 'Fabric', 'Blue', 55),
('Kitchen Island', 2, 499.99, 10, 'A versatile kitchen island.', '48x24x36 inches', 'Wood', 'White', 75),
('Gaming Chair', 3, 199.99, 7, 'A high-back gaming chair.', '27x27x53 inches', 'PU Leather', 'Red/Black', 25),
('King Bed', 4, 699.99, 5, 'A king size bed frame.', '76x80 inches', 'Metal', 'Black', 120),
('Wardrobe', 5, 599.99, 0, 'A spacious wardrobe.', '50x20x72 inches', 'Wood', 'Walnut', 150), -- Out of stock
('Sectional Sofa', 1, 999.99, 12, 'A large sectional sofa.', '100x35x30 inches', 'Fabric', 'Beige', 120),
('Dining Chair', 2, 79.99, 50, 'A set of dining chairs.', '18x20x36 inches', 'Wood', 'Natural', 15),
('Standing Desk', 3, 299.99, 14, 'An adjustable standing desk.', '55x28x45 inches', 'Metal/Wood', 'Black', 50),
('Nightstand', 4, 99.99, 24, 'A modern nightstand.', '20x16x24 inches', 'Wood', 'White', 20),
('Dresser', 5, 399.99, 18, 'A six-drawer dresser.', '60x18x36 inches', 'Wood', 'Cherry', 80),
('TV Stand', 1, 199.99, 22, 'A sleek TV stand.', '50x20x24 inches', 'Metal/Glass', 'Black', 40),
('Patio Table', 2, 179.99, 8, 'A round patio table.', '40x40x30 inches', 'Metal', 'Bronze', 35),
('Office Desk', 3, 249.99, 10, 'A spacious office desk.', '60x30x30 inches', 'Wood', 'Mahogany', 70),
('Double Bed', 4, 399.99, 6, 'A double size bed frame.', '54x75 inches', 'Metal', 'Silver', 90),
('Bookshelf Speaker', 5, 149.99, 12, 'A high-quality bookshelf speaker.', '8x8x12 inches', 'Wood/Metal', 'Black', 10);


--procedure to update product.
CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @ProductName VARCHAR(255),
    @CategoryID INT,
    @Price DECIMAL(10, 2),
    @Stock INT,
    @Description TEXT,
    @Dimensions VARCHAR(255),
    @Material VARCHAR(255),
    @Color VARCHAR(50),
    @Weight DECIMAL(10, 2)
AS
BEGIN
    UPDATE Products
    SET 
        ProductName = 'Sofa',
        CategoryID = '1',
        Price = '600',
        Stock = '45',
        Description = 'its a siting luxury',
        Dimensions = @Dimensions,
        Material = @Material,
        Color = @Color,
        Weight = @Weight
    WHERE ProductID = '1';
END;

EXEC UpdateProduct @ProductID = 1, 
                   @ProductName = 'Updated Product Name', 
                   @CategoryID = 2, 
                   @Price = 299.99, 
                   @Stock = 50, 
                   @Description = 'its a siting luxury', 
                   @Dimensions = '80x35x30 inches', 
                   @Material = 'Wood', 
                   @Color = 'Brown', 
                   @Weight = 75.0;

--delete product
CREATE PROCEDURE DeleteProduct
    @ProductID INT
AS
BEGIN
    DELETE FROM Products
    WHERE ProductID = @ProductID;
END;



-- Sample data for Customers
INSERT INTO Customers (FirstName, LastName, Email, PasswordHash, PhoneNumber, AddressLine1, AddressLine2, City, State, ZipCode, Country) VALUES
('Ahmed', 'Khan', 'ahmed.khan@example.pk', 'hashedpassword1', '03001234567', '123 Shalimar Road', '', 'Lahore', 'Punjab', '54000', 'Pakistan'),
('Fatima', 'Ali', 'fatima.ali@example.pk', 'hashedpassword2', '03007654321', '456 Liberty Market', 'Apt 3A', 'Karachi', 'Sindh', '75500', 'Pakistan'),
('Hassan', 'Raza', 'hassan.raza@example.pk', 'hashedpassword3', '03003456789', '789 Gulberg', 'Suite 202', 'Islamabad', 'ICT', '44000', 'Pakistan'),
('Ayesha', 'Sheikh', 'ayesha.sheikh@example.pk', 'hashedpassword4', '03002345678', '321 Clifton', '', 'Karachi', 'Sindh', '75500', 'Pakistan'),
('Usman', 'Qureshi', 'usman.qureshi@example.pk', 'hashedpassword5', '03004567890', '654 Mall Road', 'Floor 1', 'Lahore', 'Punjab', '54000', 'Pakistan'),
('Zainab', 'Malik', 'zainab.malik@example.pk', 'hashedpassword6', '03005678901', '987 F-8 Markaz', '', 'Islamabad', 'ICT', '44000', 'Pakistan'),
('Bilal', 'Hussain', 'bilal.hussain@example.pk', 'hashedpassword7', '03006789012', '159 I.I. Chundrigar Road', 'Floor 5', 'Karachi', 'Sindh', '75500', 'Pakistan'),
('Sana', 'Rehman', 'sana.rehman@example.pk', 'hashedpassword8', '03007890123', '753 Model Town', '', 'Lahore', 'Punjab', '54000', 'Pakistan'),
('Imran', 'Ahmad', 'imran.ahmad@example.pk', 'hashedpassword9', '03008901234', '321 Defence', 'Apt 2B', 'Lahore', 'Punjab', '54000', 'Pakistan'),
('Maryam', 'Zafar', 'maryam.zafar@example.pk', 'hashedpassword10', '03009012345', '456 DHA', '', 'Karachi', 'Sindh', '75500', 'Pakistan');

--procedure to update costumer
CREATE PROCEDURE UpdateCustomer
    @CustomerID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @PasswordHash VARCHAR(255),
    @PhoneNumber VARCHAR(15),
    @AddressLine1 VARCHAR(255),
    @AddressLine2 VARCHAR(255),
    @City VARCHAR(100),
    @State VARCHAR(100),
    @ZipCode VARCHAR(20),
    @Country VARCHAR(100)
AS
BEGIN
    UPDATE Customers
    SET 
        FirstName = 'Shahid',
        LastName = 'Zafar',
        Email = 's.zafar@example.com',
        PasswordHash = 'extraction',
        PhoneNumber = '01234566755',
        AddressLine1 = 'Rehman Garden',
        AddressLine2 = 'saggian',
        City = 'Lahore',
        State = 'Shiekpura',
        ZipCode = '54000',
        Country = 'Pakistan'
    WHERE CustomerID = 10;
END;

EXEC UpdateCustomer 
    @CustomerID = 1,
    @FirstName = 'New FirstName',
    @LastName = 'New LastName',
    @Email = 'new.email@example.com',
    @PasswordHash = 'newhashedpassword',
    @PhoneNumber = '03001234567',
    @AddressLine1 = 'New Address Line 1',
    @AddressLine2 = 'New Address Line 2',
    @City = 'New City',
    @State = 'New State',
    @ZipCode = '12345',
    @Country = 'New Country';




-- Sample data for Orders
INSERT INTO Orders (CustomerID, OrderDate, ShippingAddress, BillingAddress, OrderStatus, TotalAmount) VALUES
(3, '2023-05-17 14:00:00', '789 Gulberg, Suite 202, Islamabad, ICT, 44000, Pakistan', '789 Gulberg, Suite 202, Islamabad, ICT, 44000, Pakistan', 'Completed', 349.98), -- OrderID 3
(4, '2023-06-12 16:00:00', '321 Clifton, Karachi, Sindh, 75500, Pakistan', '321 Clifton, Karachi, Sindh, 75500, Pakistan', 'Shipped', 599.99),
(1, '2023-06-15 10:00:00', '123 Shalimar Road, Lahore, Punjab, 54000, Pakistan', '123 Shalimar Road, Lahore, Punjab, 54000, Pakistan', 'Completed', 1498.97), -- OrderID 1
(2, '2023-06-16 12:00:00', '456 Liberty Market, Apt 3A, Karachi, Sindh, 75500, Pakistan', '456 Liberty Market, Apt 3A, Karachi, Sindh, 75500, Pakistan', 'Pending', 399.98), -- OrderID 2
(3, '2023-06-17 14:00:00', '789 Gulberg, Suite 202, Islamabad, ICT, 44000, Pakistan', '789 Gulberg, Suite 202, Islamabad, ICT, 44000, Pakistan', 'Completed', 899.98), -- OrderID 3
(4, '2023-06-18 16:00:00', '321 Clifton, Karachi, Sindh, 75500, Pakistan', '321 Clifton, Karachi, Sindh, 75500, Pakistan', 'Shipped', 649.98), -- OrderID 4
(5, '2023-06-19 18:00:00', '654 Mall Road, Floor 1, Lahore, Punjab, 54000, Pakistan', '654 Mall Road, Floor 1, Lahore, Punjab, 54000, Pakistan', 'Processing', 349.98), -- OrderID 5
(6, '2023-06-20 20:00:00', '987 F-8 Markaz, Islamabad, ICT, 44000, Pakistan', '987 F-8 Markaz, Islamabad, ICT, 44000, Pakistan', 'Completed', 499.99), -- OrderID 6
(7, '2023-06-21 22:00:00', '159 I.I. Chundrigar Road, Floor 5, Karachi, Sindh, 75500, Pakistan', '159 I.I. Chundrigar Road, Floor 5, Karachi, Sindh, 75500, Pakistan', 'Pending', 799.99), -- OrderID 7
(8, '2023-06-22 09:00:00', '753 Model Town, Lahore, Punjab, 54000, Pakistan', '753 Model Town, Lahore, Punjab, 54000, Pakistan', 'Shipped', 299.99), -- OrderID 8
(9, '2023-06-23 11:00:00', '321 Defence, Apt 2B, Lahore, Punjab, 54000, Pakistan', '321 Defence, Apt 2B, Lahore, Punjab, 54000, Pakistan', 'Processing', 399.99), -- OrderID 9
(10, '2023-06-24 13:00:00', '456 DHA, Karachi, Sindh, 75500, Pakistan', '456 DHA, Karachi, Sindh, 75500, Pakistan', 'Completed', 599.99); -- OrderID 10


-- Sample data for OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 599.99),   -- OrderID 1
(2, 2, 1, 299.99),   -- OrderID 1
(3, 3, 2, 149.99),   -- OrderID 2
(4, 4, 1, 499.99),   -- OrderID 2
(5, 5, 1, 199.99),   -- OrderID 3
(6, 6, 1, 799.99),   -- OrderID 3
(7, 7, 1, 129.99),   -- OrderID 4
(8, 8, 1, 89.99),    -- OrderID 4
(9, 1, 1, 599.99),   -- OrderID 5
(10, 2, 1, 299.99),   -- OrderID 5
(11, 3, 2, 149.99),  -- OrderID 6
(12, 4, 1, 499.99);  -- OrderID 6


delete from OrderItems;

-- Sample data for Payments
INSERT INTO Payments (OrderID, PaymentAmount, PaymentMethod, TransactionID) VALUES
(1, 1498.97, 'Credit Card', 'CC1234567890'),
(2, 399.98, 'PayPal', 'PP9876543210'),
(3, 899.98, 'Debit Card', 'DC5678901234'),
(4, 649.98, 'Credit Card', 'CC2345678901'),
(5, 349.98, 'PayPal', 'PP8765432109'),
(6, 499.99, 'Debit Card', 'DC3456789012'),
(7, 799.99, 'Credit Card', 'CC3456789012'),
(8, 299.99, 'PayPal', 'PP7654321098'),
(9, 399.99, 'Debit Card', 'DC4567890123'),
(10, 599.99, 'Credit Card', 'CC4567890123');


UPDATE Payments
SET PaymentMethod = 'Cash on Delivery'
WHERE PaymentMethod = 'PayPal';


-- Sample data for Reviews
INSERT INTO Reviews (ProductID, CustomerID, Rating, ReviewText, ReviewDate) VALUES
(6, 6, 4, 'Luxurious sofa, comfortable and stylish.', '2023-06-27 10:00:00'),
(7, 7, 3, 'Table is fine, but assembly was challenging.', '2023-06-28 12:00:00'),
(8, 8, 5, 'Love the design of this chair!', '2023-06-29 14:00:00'),
(9, 9, 1, 'Bed frame broke within a week.', '2023-06-30 16:00:00'),
(10, 10, 4, 'Great storage cabinet, spacious and sturdy.', '2023-07-01 18:00:00'),
(1, 3, 3, 'Sofa is okay, fabric is not as expected.', '2023-07-02 10:00:00'),
(2, 4, 5, 'Table is perfect for our dining room.', '2023-07-03 12:00:00'),
(3, 5, 2, 'Chair is not ergonomic, uncomfortable for long use.', '2023-07-04 14:00:00'),
(4, 6, 4, 'Good quality bed frame, easy to assemble.', '2023-07-05 16:00:00'),
(5, 7, 3, 'Cabinet arrived damaged, disappointed with quality control.', '2023-07-06 18:00:00');


-- Sample data for OutOfStockItems
INSERT INTO OutOfStock (ProductID, ProductName, OutOfStockDate)
VALUES
(5, 'Storage Cabinet', '2023-06-30'),
(8, 'Bar Stool', '2023-07-01'),
(14, 'Wardrobe', '2023-09-01');

--Show Tables

SELECT * FROM Categories;
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM OutOfStock;
SELECT * FROM Payments;
SELECT * FROM Reviews;


-- Calculate value of each order and total value of all orders
SELECT 
    o.OrderID, 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate, 
    o.TotalAmount
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID;

SELECT 
    SUM(TotalAmount) AS TotalValueOfAllOrders
FROM 
    Orders;

--Query to find costumer with more than 1 order
SELECT * 
FROM Customers
WHERE CustomerID IN (
  SELECT CustomerID 
  FROM Orders
  GROUP BY CustomerID
  HAVING COUNT(*) > 1
);


-- Query to show data for a specific customer by CustomerID
SELECT 
    CustomerID,
    FirstName,
    LastName,
    Email,
    PhoneNumber,
    AddressLine1,
    AddressLine2,
    City,
    State,
    ZipCode,
    Country,
    RegistrationDate
FROM 
    Customers
WHERE 
    CustomerID = 1;

-- Query to show data for a specific order by OrderID
SELECT 
    o.OrderID,
    o.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate,
    o.ShippingAddress,
    o.BillingAddress,
    o.OrderStatus,
    o.TotalAmount
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderID = 5; 

-- Query to show all orders placed by a specific customer by CustomerID
SELECT 
    o.OrderID,
    o.OrderDate,
    o.ShippingAddress,
    o.BillingAddress,
    o.OrderStatus,
    o.TotalAmount
FROM 
    Orders o
WHERE 
    o.CustomerID = 7; 

-- Query to show detailed information for a specific order including order items
SELECT 
    o.OrderID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate,
    o.ShippingAddress,
    o.BillingAddress,
    o.OrderStatus,
    o.TotalAmount,
    oi.OrderItemID,
    p.ProductName,
    oi.Quantity,
    oi.Price
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    OrderItems oi ON o.OrderID = oi.OrderID
JOIN 
    Products p ON oi.ProductID = p.ProductID
WHERE 
    o.OrderID = 8; 

--Query to list the total number of orders and total order amount for each customer
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(COALESCE(oi.Quantity * oi.Price, 0)) AS TotalOrderAmount
FROM
    Customers c
LEFT JOIN
    Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN
    OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY
    c.CustomerID;


--Find All Products with Less Than a Specified Quantity in Stock
SELECT
    ProductID,
    ProductName,
    Stock
FROM
    Products
WHERE
    Stock < 9;

--List All Pending Orders with Customer and Shipping Details
SELECT
    o.OrderID,
    o.OrderDate,
    o.ShippingAddress,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    c.PhoneNumber,
    c.AddressLine1,
    c.AddressLine2,
    c.City,
    c.State,
    c.ZipCode,
    c.Country
FROM
    Orders o
JOIN
    Customers c ON o.CustomerID = c.CustomerID
WHERE
    o.OrderStatus = 'Pending'
ORDER BY
    o.OrderDate;

--Retrieve All Orders Made by a Specific Customer
SELECT
    o.OrderID,
    o.OrderDate,
    o.ShippingAddress,
    o.BillingAddress,
    o.OrderStatus,
    o.TotalAmount
FROM
    Orders o
WHERE
    o.CustomerID = 2
ORDER BY
    o.OrderDate;

--query to show customers that gave the reviews
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    r.ReviewID,
    p.ProductName,
    r.ReviewText AS Comment,
    r.ReviewDate
FROM
    Reviews r
JOIN
    Customers c ON r.CustomerID = c.CustomerID
JOIN
    Products p ON r.ProductID = p.ProductID
ORDER BY
    r.ReviewDate DESC;

--Top Product Sold
SELECT TOP 1
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold
FROM
    OrderItems oi
JOIN
    Products p ON oi.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalQuantitySold DESC;





SELECT COUNT(*) AS total_orders
FROM orders;


select sum(TotalAmount) as total
from Orders;


select avg (Price) as avg_am
from Products;

select min(price) as min_val
from Products;

select max(price) as min_val
from Products;


select * from Products
where ProductID = 1;


select * from Products
where ProductName = 'Bar Stool';

select * from Orders
where TotalAmount > 1000;

select * from Orders
where TotalAmount < 500;

select * from Orders
where TotalAmount = 399.99;

select * from Orders
where OrderID = 3 or OrderStatus = 'Shipped';

select * from Orders
where OrderID = 3 and OrderStatus = 'Shipped';

select * from Customers
where FirstName like 'A%';

select * from Products
where Price between 399.99 and 1500;

update Products
set Price = 400
where ProductID = 10;



select * from Products;