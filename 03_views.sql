
--IN THIS VIEW I CAN CHECK THE TOP 3 COSTS IN EACH MONTH

CREATE VIEW TOP3COSTS_MONTHLY AS
WITH CostsCTE as(
--THE RETURNS THE CATEGORY SUBCATEGORY NAMES AND MONTHNAME FOR THE TRANSACTIONS
   SELECT 
		t.OWNER,
		format(Month([DATE]),'00') + '-' + DATENAME(MONTH,[DATE]) AS MONTHNAME,
        c.Categoryname as Category,
		s.SubCategoryName as Subcategory,
		SUM(t.AMOUNT) as Amount   
    FROM 
        Transactions t
		left join subcategory s on t.subcategoryID = s.subcategoryid
		Left join category c on s.CategoryID=c.CategoryID
	Where Amount < 0
	GROUP BY t.OWNER,
		format(Month([DATE]),'00') + '-' + DATENAME(MONTH,[DATE]),
        c.Categoryname,
		s.SubCategoryName
) ,
rankedCosts as (
--RANKS THE TRANSACTIONS FOR EACH MONTH FROM LOWEST TO HIGHEST
Select
	[Owner],
	Monthname,
	category,
	subcategory,
	Amount,
	ROW_NUMBER() OVER (PARTITION BY [Owner],monthname ORDER BY AMOUNT ASC) AS ROWNUMBER

	FROM COSTSCTE
)	
	
--SELECTS TOP 3 TRANSACTION FOR EACH MONTH
Select	[OWNER],MONTHNAME,CATEGORY,SUBCATEGORY, AMOUNT
from rankedCosts
where rownumber <=3
order by [Owner],Monthname,rownumber asc