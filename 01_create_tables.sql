CREATE DATABASE Test;
GO

USE Test;
GO
CREATE SCHEMA Fact;
GO
CREATE SCHEMA Dimension;
GO
--adding Category table
CREATE TABLE
	Dimension.Category (
		ID INT NOT NULL,
		CategoryName NVARCHAR(50) NOT NULL,
		CONSTRAINT PK_CATEGORY PRIMARY KEY (ID)
	);

GO
BULK INSERT Dimension.Category
FROM
	'D:\fullpath\Categories.csv'
WITH
	(
		FIELDTERMINATOR = '|',
		FIELDQUOTE = '"',
		FORMAT = 'CSV',
		FIRSTROW = 2,
		ROWTERMINATOR = '0x0A',
		CODEPAGE = '65001'
	);

GO
--adding subcategories table
CREATE TABLE
	Dimension.Subcategory (
		ID INT NOT NULL,
		SubCategoryName NVARCHAR(50) NOT NULL,
		SubCategoryType NVARCHAR(50) NOT NULL,
		CategoryID INT NOT NULL,
		CONSTRAINT PK_SUBCATEGORY PRIMARY KEY (ID),
		CONSTRAINT FK_SUBCATEGORY_CATEGORY FOREIGN KEY (CategoryID) REFERENCES Dimension.Category (ID)
	);

GO

BULK INSERT Dimension.Subcategory
FROM
	'D:\fullpath\Subcategories.csv'
WITH
	(
		FIELDTERMINATOR = '|',
		FIELDQUOTE = '"',
		FORMAT = 'CSV',
		FIRSTROW = 2,
		ROWTERMINATOR = '0x0A',
		CODEPAGE = '65001'
	);

GO
--adding expressions table
CREATE TABLE
	Dimension.Expressions (
		SubCategoryID INT NOT NULL,
		Expression NVARCHAR(50) UNIQUE NOT NULL,
		CONSTRAINT FK_EXPRESSIONS_SUBCATEGORY FOREIGN KEY (SubCategoryID) REFERENCES Dimension.Subcategory (ID),
		CONSTRAINT PK_EXPRESSIONS PRIMARY KEY (Expression)
	);

GO

BULK INSERT Dimension.Expressions
FROM
	'D:\fullpath\Expressions.csv'
WITH
	(
		FIELDTERMINATOR = '|',
		FIELDQUOTE = '"',
		FORMAT = 'CSV',
		FIRSTROW = 2,
		ROWTERMINATOR = '0x0A',
		CODEPAGE = '65001'
	);

GO
/* -these tables will be populated with ssis, working on it
CREATE TABLE Dimension.[Owner](
ID nvarchar(10),
[Name] nvarchar(20),

CONSTRAINT PK_OWNER PRIMARY KEY (ID)
);
GO

CREATE TABLE Dimension.[Date](
DateKey varchar(20),


CONSTRAINT PK_DATE PRIMARY KEY (Datekey)
);
GO*/
--Adding all data table
CREATE TABLE
	Fact.Transactions (
		TransactionID INT IDENTITY(1, 1),
		OwnerID NVARCHAR(10),
		Datekey VARCHAR(20),
		SubCategoryID INT,
		[Description] NVARCHAR(200),
		Amount DECIMAL(10, 2),
		CONSTRAINT FK_TRANSACTIONS_SUBCATEGORY FOREIGN KEY (SubCategoryID) REFERENCES Dimension.Subcategory (ID),
		/*CONSTRAINT FK_TRANSACTIONS_DATE  FOREIGN KEY (Datekey) REFERENCES Dimension.[Date] (Datekey),
		CONSTRAINT FK_TRANSACTIONS_OWNER  FOREIGN KEY (OwnerID) REFERENCES Dimension.[Owner] (ID),*/
		CONSTRAINT PK_TRANSACTIONS PRIMARY KEY (TransactionID)
	);

GO

CREATE TABLE
	Transactions_Staging (
		OwnerID NVARCHAR(10),
		Datekey VARCHAR(20),
		SubCategoryID INT,
		[Description] NVARCHAR(200),
		Amount DECIMAL(10, 2),
	);

GO

BULK INSERT Transactions_Staging
FROM
	'D:\fullpath\all_data.csv'
WITH
	(
		FIELDTERMINATOR = ',',
		FIELDQUOTE = '"',
		FORMAT = 'CSV',
		FIRSTROW = 2,
		ROWTERMINATOR = '0x0A',
		CODEPAGE = '65001'
	);

GO
INSERT INTO
	Fact.Transactions (
		OwnerID,
		Datekey,
		SubCategoryID,
		[Description],
		Amount
	)
SELECT
	OwnerID,
	Datekey,
	SubCategoryID,
	[Description],
	Amount
FROM
	Transactions_Staging;

GO