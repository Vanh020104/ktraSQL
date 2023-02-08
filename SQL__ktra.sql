CREATE DATABASE AZBank
GO
USE AZBank
GO


CREATE TABLE Customer  (
	CustomerId INT PRIMARY KEY NOT NULL,
	NAME nvarchar(50),
	City nvarchar(50),
	Country nvarchar(50),
	Phone nvarchar(15),
	Email nvarchar(50),
	)

CREATE TABLE CustomerAccount (
	AccountNumber char(9) Primary Key Not NULL,
	CustomerId int NOT NULL,
	Balance money NOT NULL,
	MinAccount money,
	)


CREATE TABLE CustomerTransaction (
	TransactionId int Primary Key NOT NULL,
	AccountNumber char(9),
	TransactionDate smalldatetime,
	Amount money,
	DepositorWithdraw bit,
	)


--3 chèn vào mỗi bản ít nhất 3 bảng ghi

INSERT INTO Customer values
(1, 'Nguyen Thi A', 'Mycompany', 'HaiDuong', '001', 'nguyenthia@gmail.com'),
(2, 'Nguyen Van B', 'Google', 'HoChiMinh', '002', 'nguyenvanb@gmail.com'),
(3, 'Nguyen Thuy C', 'Grap', 'HaNoi', '003', 'nguyenthuyc@gmail.com')

INSERT INTO CustomerAccount values
('nta', 1, 20000, ''),
('nvb', 2, 20000, ''),
('ntc', 3, 20000, '')


INSERT INTO CustomerTransaction values
(1, 'nta', '','',''),
(2, 'nvb', '','',''),
(3, 'ntc', '','','')

SELECT *
FROM Customer

SELECT *
FROM CustomerAccount

SELECT *
FROM CustomerTransaction

--4

SELECT *
FROM Customer
WHERE Country = 'HaNoi'


--5


SELECT name, email, phone, Country, City, AccountNumber
FROM Customer  c
JOIN CustomerAccount  cu
ON c.CustomerId = cu.CustomerId

--6 
ALTER TABLE CustomerTransaction 
ADD CONSTRAINT CK_Amount 
CHECK (Amount > 0 AND Amount <=1000000);
---7 
CREATE NONCLUSTERED INDEX IX_Customer_Name 
ON Customer (Name);



--8

--9--
CREATE PROCEDURE spAddCustomer (@CustomerId INT, @CustomerName VARCHAR(50), @Country VARCHAR(50), @Phone VARCHAR(50), @Email VARCHAR(50))
AS
BEGIN
    INSERT INTO Customer (CustomerId, Name, Country, Phone, Email)
    VALUES (@CustomerId, @CustomerName, @Country, @Phone, @Email)
END

EXEC spAddCustomer 1, 'John Doe', 'Hanoi', '123 456 789', 'johndoe@email.com'
EXEC spAddCustomer 2, 'Jane Doe', 'Hanoi', '0987 654 321', 'janedoe@email.com'
EXEC spAddCustomer 3, 'Jim Smith', 'USA', '+1 123 456 789', 'jimsmith@email.com'



--10--
CREATE PROCEDURE spGetTransactions (@AccountNumber INT, @FromDate DATE, @ToDate DATE)
AS
BEGIN
    SELECT Customer.Name, CustomerAccount.AccountNumber, CustomerTransaction.TransactionDate, CustomerTransaction.Amount, CustomerTransaction.DepositorWithdraw
    FROM Customer
    INNER JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId
    INNER JOIN CustomerTransaction ON CustomerAccount.AccountNumber = CustomerTransaction.AccountNumber
    WHERE CustomerAccount.AccountNumber = @AccountNumber
      AND CustomerTransaction.TransactionDate BETWEEN @FromDate AND @ToDate
END