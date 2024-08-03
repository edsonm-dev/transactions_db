
--IN THIS VIEW I CAN CHECK THE TOP 3 COSTS IN EACH MONTH

CREATE VIEW TOP3COSTS_MONTHLY AS
WITH CostsCTE AS(
--THE RETURNS THE CATEGORY SUBCATEGORY NAMES AND MONTHNAME FOR THE TRANSACTIONS
   SELECT 
		t.OWNER,
		format(Month([DATE]),'00') + '-' + DATENAME(MONTH,[DATE]) AS MONTHNAME,
        c.Categoryname AS Category,
		s.SubCategoryName AS Subcategory,
		SUM(t.AMOUNT) AS Amount   
    FROM 
        Transactions t
		LEFT JOIN subcategory s ON t.subcategoryID = s.subcategoryid
		LEFT JOIN category c ON s.CategoryID=c.CategoryID
	WHERE Amount < 0
	GROUP BY t.OWNER,
		format(Month([DATE]),'00') + '-' + DATENAME(MONTH,[DATE]),
        c.Categoryname,
		s.SubCategoryName
) ,
rankedCosts AS (
--RANKS THE TRANSACTIONS FOR EACH MONTH FROM LOWEST TO HIGHEST
SELECT
	[Owner],
	Monthname,
	category,
	subcategory,
	Amount,
	ROW_NUMBER() OVER (PARTITION BY [Owner],monthname ORDER BY AMOUNT ASC) AS ROWNUMBER

	FROM COSTSCTE
)	
	
--SELECTS TOP 3 TRANSACTION FOR EACH MONTH
SELECT	[OWNER],MONTHNAME,CATEGORY,SUBCATEGORY, AMOUNT
FROM rankedCosts
WHERE  rownumber <=3
ORDER BY [Owner],Monthname,rownumber ASC