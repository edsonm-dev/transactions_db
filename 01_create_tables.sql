


create database Test;


--adding Category table


Create table test.dbo.category (
	CategoryID int PRIMARY KEY NOT NULL,
	CategoryName nvarchar(50) NOT NULL,

);



BULK INSERT test.dbo.category
from 'D:\full_path\categories.csv'
with (
	FIELDTERMINATOR='|',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	);



--adding subcategories table

Create table test.dbo.subcategory (
	SubCategoryID int PRIMARY KEY NOT NULL,
	SubCategoryName nvarchar(50) NOT NULL,
	SubCategoryType nvarchar(50) NOT NULL,
	CategoryID int NOT NULL FOREIGN KEY REFERENCES category(CategoryID) ON UPDATE CASCADE --Cascade ensures that if i update a CategoryID in the category table it gets updated here as well
	
);

BULK INSERT test.dbo.subcategory
from 'D:\full_path\subcategories.csv'
with (
	FIELDTERMINATOR='|',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	);

--adding expressions table

Create table test.dbo.expressions (
	SubCategoryID int NOT NULL FOREIGN KEY REFERENCES subcategory(SubCategoryID) ON UPDATE CASCADE, --If i delete a category from subcategory table then it will be updated here as well
	Expression nvarchar(50) not null PRIMARY KEY

);



BULK INSERT test.dbo.expressions
from 'D:\full_path\expressions.csv'
with (
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
from 'D:\full_path\transactions.csv'
with (
	FIELDTERMINATOR=',',
	FIELDQUOTE='"',
	FORMAT='CSV',
	FIRSTROW=2,
	ROWTERMINATOR='0x0A',
	CODEPAGE = '65001'
	
	
	);

