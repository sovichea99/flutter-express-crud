-- Create the ProductDB database
CREATE DATABASE ProductDB;
GO

-- Use the ProductDB database
USE ProductDB;
GO

-- Create the PRODUCTS table
CREATE TABLE PRODUCTS (
    PRODUCTID INT PRIMARY KEY IDENTITY(1,1),
    PRODUCTNAME NVARCHAR(100) NOT NULL,
    PRICE DECIMAL(10, 2) NOT NULL,
    STOCK INT NOT NULL
);
GO

-- Insert sample data into PRODUCTS
INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK)
VALUES
('Laptop', 999.99, 10),
('Phone', 499.99, 5),
('Tablet', 599.99, 8);
GO

-- Verify the inserted data
SELECT * FROM PRODUCTS;
GO

-- Update an existing product 
UPDATE PRODUCTS
SET
    PRODUCTNAME = 'Macbook Pro M4',
    PRICE = 1299.99,
    STOCK = 18
WHERE 
    PRODUCTID = 1;
GO