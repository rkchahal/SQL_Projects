/*
1. What is the difference between Primary Key (PK) and Foreign Key (FK)?
A Primary Key uniquely identifies each record in a table and does not allow NULL or duplicate values.
A Foreign Key is a field in one table that refers to the Primary Key in another table, enforcing referential 
integrity between related tables.

2. What is the difference between a View, a Table, and a Temporary Table?
A Table is a physical structure that stores persistent data in rows and columns.
A View is a virtual table created using a SQL query; it does not store data itself but displays data from 
one or more tables.
A Temporary Table is a table created temporarily for storing intermediate results; it is deleted automatically 
when the session ends.

3. What is the difference between Clustered and Non-clustered Indexes?
A Clustered Index determines the physical order of data in a table and only one is allowed per table.
A Non-clustered Index is a separate structure that maintains a pointer to the actual data, and a table can 
have multiple non-clustered indexes.

4. What is the difference between Stored Procedures and Functions?
A Stored Procedure is a compiled set of SQL statements that can perform actions such as INSERT, UPDATE, 
DELETE, and return multiple results.
A Function returns a single value or a table and is used mainly for computations; it must return a value 
and cannot modify data.

5. What is the ACID property in a database?
ACID stands for Atomicity, Consistency, Isolation, and Durability, which are the key properties ensuring 
reliable transaction processing:
Atomicity: Transactions are all-or-nothing.
Consistency: Ensures data remains valid after a transaction.
Isolation: Concurrent transactions do not interfere with each other.
Durability: Once committed, changes are permanent even after a system failure.

*/

CREATE DATABASE XYZ;
USE XYZ;

CREATE TABLE Activity_checking (
    Obs INT,
    Client_ID INT,
    Account_ID INT,
    Open_Date DATE,
    Assets INT,
    Status VARCHAR(10)
);

CREATE TABLE Activity_creditcard (
Obs INT,
Client_ID INT,
Account_ID INT, 
Open_date DATE,
Credit_Status VARCHAR(10),
Assets INT
);

Select * from Activity_checking;

INSERT INTO Activity_checking VALUES
(1, 1001, 20032, '2019-11-02', 7744, 'Active'),
(2, 1002, 20056, '2020-12-12', -12451, 'Inactive'),
(3, 1003, 20032, '2019-01-12', 1274, 'Active'),
(4, 1003, 20074, '2019-01-19', 7683, 'Active'),
(5, 1002, 20793, '2017-09-17', -591, 'Active'),
(6, 1004, 20142, '2017-02-16', 14144, 'Active'),
(7, 1005, 21943, '2016-10-24', 13981, 'Active'),
(8, 1006, 29371, '2008-06-09', 14049, 'Inactive'),
(9, 1002, 29081, '2018-04-05', 2092, 'Active');

INSERT INTO Activity_creditcard VALUES
(1, 1003, 313058, '2015-12-17', 'Active', -4059),
(2, 1004, 339524, '2019-01-16', 'Active', -4327),
(3, 1002, 330572, '2019-09-26', 'Active', 15392),
(4, 1003, 396821, '2020-02-07', 'Inactive', -1359),
(5, 1004, 375271, '2018-03-15', 'Active', -1601),
(6, 1003, 373859, '2020-09-09', 'Active', 16515),
(7, 1006, 383733, '2017-11-08', 'Inactive', 5226),
(8, 1006, 353413, '2018-03-16', 'Inactive', 13741),
(9, 1005, 365605, '2017-06-25', 'Active', -4110);

SELECT * FROM Activity_creditcard;


/*
Task: Create a Summary Report Tracking KPI Metrics, For each active client, 
create a summary report with the following metrics:*/

/*
1. XYZ_Since_Date: The first date when the customer started a relationship with XYZ 
(earliest Open_Date from both datasets).*/
SELECT Client_ID, min(Open_date) as XYZ_Since_Date
FROM
(
SELECT Client_ID, Open_Date FROM Activity_checking
  UNION ALL
SELECT Client_ID, Open_Date FROM Activity_creditcard
)
AS combined_date
GROUP BY Client_ID;

-- Product1_Since_Date (checking)
SELECT Client_ID, MIN(Open_Date) AS Product1_Since_Date
FROM Activity_checking
GROUP BY Client_ID;

-- Product2_Since_Date (credit card)
SELECT Client_ID, MIN(Open_Date) AS Product2_Since_Date
FROM Activity_creditcard
GROUP BY Client_ID;

-- Total_Actives
SELECT Client_ID, COUNT(*) AS Total_Actives
FROM (
    SELECT Client_ID FROM Activity_checking WHERE Status = 'Active'
    UNION ALL
    SELECT Client_ID FROM Activity_creditcard WHERE Credit_Status = 'Active'
) AS ActiveAccounts
GROUP BY Client_ID;

-- Total_Assets
SELECT Client_ID, SUM(Assets) AS Total_Assets
FROM (
    SELECT Client_ID, Assets FROM Activity_checking
    UNION ALL
    SELECT Client_ID, Assets FROM Activity_creditcard
) AS AllAssets
GROUP BY Client_ID;

-- Section 3
CREATE TABLE Product_Sales1 (
product INT,
no INT,
q INT,
price DECIMAL(10, 2)
);

INSERT INTO Product_Sales1 VALUES
(23, 3, 12, 250.00),
(23, 15, 24, 450.00),
(23, 25, 16, 346.00),
(46, 45, 25, 560.00);

CREATE TABLE Product_Sales2 (
product INT,
no INT,
price DECIMAL(10, 2)
);

INSERT INTO Product_Sales2 VALUES
(46, 23, 250.00),
(27, 15, 450.00),
(37, 25, 36.00),
(46, 50, 700.00);

--POS Tables: Sales Data
--POS1 Table:
CREATE TABLE POS1 (
date DATE,
sales DECIMAL(10, 2),
product INT,
no INT
);

INSERT INTO POS1 VALUES
('2001-01-22', 250.00, 23, 3),
('2002-01-22', 300.00, 27, 15);

--POS2 Table:
CREATE TABLE POS2 (
date DATE,
sales DECIMAL(10, 2),
product INT,
no INT
);

INSERT INTO POS2 VALUES
('2001-01-22', 280.00, 23, 3),
('2002-01-22', 150.00, 37, 25);

--POS3 Table:
CREATE TABLE POS3 (
date DATE,

sales DECIMAL(10, 2),
product INT,
no INT
);

INSERT INTO POS3 VALUES
('2001-01-22', 280.00, 23, 3),
('2002-01-22', 400.00, 27, 15);

-- 1. Find Duplicates
SELECT * FROM Product_Sales1
INTERSECT
SELECT product, no, NULL AS q, price FROM Product_Sales2;

-- 2. Merge Tables (include duplicates)
SELECT product, no, q, price 
INTO Merged_Table
FROM Product_Sales1

UNION ALL

SELECT product, no, NULL AS q, price 
FROM Product_Sales2;

-- 3. Remove Duplicates
SELECT DISTINCT *
INTO Cleaned_Table
FROM Merged_Table;

-- 4. Create temporary sales summary table from POS1, POS2, POS3
SELECT *
INTO Temp_Sales_Summary
FROM POS1
UNION ALL
SELECT * FROM POS2
UNION ALL
SELECT * FROM POS3;

-- 5. Sales Aggregation
SELECT product, SUM(sales) AS Total_Sales
FROM Temp_Sales_Summary
GROUP BY product;

-- 6. Sales Report
SELECT 
  product, 
  SUM(sales) AS Total_Sales,
  COUNT(DISTINCT date) AS Distinct_Dates,
  AVG(sales) AS Avg_Sales_Per_Txn
FROM Temp_Sales_Summary
GROUP BY product;


--Section 4
-- Create table: Txn_tbl
CREATE TABLE Txn_tbl (
  customer_id INT,
  txn_id INT,
  Txn_type_key INT,
  amount DECIMAL(10, 2)
);

-- Insert sample data into Txn_tbl
INSERT INTO Txn_tbl (customer_id, txn_id, Txn_type_key, amount) VALUES
(1, 1001, 3125, 100),
(1, 1002, 3124, 50),
(2, 1003, 3546, 200),
(1, 1004, 3543, 50),
(3, 1005, 14, 30),
(2, 1006, 3125, 20),
(2, 1007, 3600, 10),
(1, 1008, 1600, 20);

-- Create table: Account_tbl
CREATE TABLE Account_tbl (
  customer_id INT,
  account_id INT,
  create_date DATE
);

-- Insert sample data into Account_tbl
INSERT INTO Account_tbl (customer_id, account_id, create_date) VALUES
(1, 101, '2022-09-01'),
(1, 102, '2023-11-15'),
(1, 103, '2025-01-01'),
(2, 104, '2018-10-22'),
(3, 105, '2020-09-18');
-- ---------------------------------------------

-- 1. Most recent account per customer
SELECT customer_id, MAX(create_date) AS Latest_Account_Date
FROM Account_tbl
GROUP BY customer_id;

-- 2. Join Txn_tbl with most recent account per customer
SELECT 
    T.*, 
    A.account_id
FROM 
    Txn_tbl T
JOIN (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY create_date DESC) AS rn
    FROM 
        Account_tbl
) A ON T.customer_id = A.customer_id AND A.rn = 1;

-- 3. Total transaction amount per customer with most recent account
SELECT 
    T.customer_id, 
    SUM(T.amount) AS Total_Txn_Amount, 
    A.account_id
FROM 
    Txn_tbl T
JOIN 
    Account_tbl A ON T.customer_id = A.customer_id
    AND A.create_date = (
        SELECT MAX(create_date) 
        FROM Account_tbl 
        WHERE customer_id = A.customer_id
    )
GROUP BY 
    T.customer_id, A.account_id;

-- 4. Handling customers with no account records
-- Use LEFT JOIN to preserve all transaction records
SELECT T.*, A.account_id
FROM Txn_tbl T
LEFT JOIN Account_tbl A ON T.customer_id = A.customer_id;

-- 5. Indexing Strategy
-- Add indexes to improve join and filter performance
CREATE NONCLUSTERED INDEX idx_txn_customer ON Txn_tbl (customer_id);
CREATE NONCLUSTERED INDEX idx_account_customer_date ON Account_tbl (customer_id, create_date);

-- 6. Transaction summary report per customer
SELECT 
  customer_id,
  COUNT(CASE WHEN Txn_type_key IN (3125, 3124, 3600, 4500, 6577, 8900) THEN 1 END) AS Credit_Count,
  SUM(CASE WHEN Txn_type_key IN (3125, 3124, 3600, 4500, 6577, 8900) THEN amount END) AS Credit_Total,
  COUNT(CASE WHEN Txn_type_key IN (3546, 3543, 14, 1600, 8700, 8888) THEN 1 END) AS Debit_Count,
  SUM(CASE WHEN Txn_type_key IN (3546, 3543, 14, 1600, 8700, 8888) THEN amount END) AS Debit_Total
FROM Txn_tbl
GROUP BY customer_id;
