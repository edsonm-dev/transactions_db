


CREATE DATABASE Test;


--adding Category table


CREATE TABLE test.dbo.category (
	CategoryID INT PRIMARY KEY NOT NULL,
	CategoryName NVARCHAR(50) NOT NULL,

);



BULK INSERT test.dbo.category
FROM 'D:\full_path\categories.csv'
WITH (
	FIELDTERMINATOR='|',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	);



--adding subcategories table

CREATE TABLE test.dbo.subcategory (
	SubCategoryID INT PRIMARY KEY NOT NULL,
	SubCategoryName NVARCHAR(50) NOT NULL,
	SubCategoryType NVARCHAR(50) NOT NULL,
	CategoryID INT NOT NULL FOREIGN KEY REFERENCES category(CategoryID) ON UPDATE CASCADE --Cascade ensures that if i update a CategoryID in the category table it gets updated here as well
	
);

BULK INSERT test.dbo.subcategory
FROM 'D:\full_path\subcategories.csv'
WITH (
	FIELDTERMINATOR='|',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	);

--adding expressions table

CREATE TABLE test.dbo.expressions (
	SubCategoryID INT NOT NULL FOREIGN KEY REFERENCES subcategory(SubCategoryID) ON UPDATE CASCADE, --If i delete a category from subcategory table then it will be updated here as well
	Expression NVARCHAR(50) NOT NULL PRIMARY KEY

);



BULK INSERT test.dbo.expressions
FROM 'D:\full_path\expressions.csv'
WITH (
	FIELDTERMINATOR='|',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	);


--Adding transactions table from file


CREATE TABLE Test.dbo.transactions (
	
	[OWNER] NVARCHAR(10),
	[DATE] DATE,
	SubCategoryID INT FOREIGN KEY REFERENCES subcategory(SubCategoryID)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	[Description] NVARCHAR(200),
	Amount DECIMAL(10,2)

);






BULK INSERT Test.dbo.transactions
FROM 'D:\full_path\transactions.csv'
WITH (
	FIELDTERMINATOR=',',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	
	
	);

