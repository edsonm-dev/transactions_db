
--STORED PROCEDURE TO INSERT A NEW TRANSACTION INTO THE TRANSACTION TABLE WITH FOR EXAMPLE A PYTHON CODE
--AFTER THE INSERT, THE CODE TRIES TO FIND THE SUBCATEGORY ID BASED ON THE EXPRESSION TABLE

CREATE PROCEDURE InsertUpdateTransactions
(@Owner  nvarchar(50),
@Date  date,
@Description   nvarchar(200),
@Amount decimal(20,2)
)
as

Begin

	SET NOCOUNT ON;

	INSERT INTO Test.dbo.transactions ([OWNER],[DATE],[Description],[Amount])
	VALUES (@Owner, @Date, @Description, @Amount)


	DECLARE @NewSubID INT;

	SELECT TOP 1 @NewSubID =  e.SubCategoryID
	FROM Test.dbo.expressions e
	WHERE @Description LIKE '%'+ e.Expression + '%' 
	order by len(e.expression) desc

	UPDATE Test.dbo.transactions 
	SET SUBCATEGORYID = @NewSubId
	WHERE TransactionID=SCOPE_IDENTITY();

End;

--CREATING THE SAME AUTOMATION WITH TRIGGER FOR PRACTICE
--IF THERE IS A NEW TRANSACTION INSERTED IN THE TRANSACTIONS TABLE, IT TRIES TO FIND THE SUBCATEGORY ID IN THE EXPRESSION TABLE

CREATE TRIGGER SubCategoryUpdate on
Test.dbo.transactions after insert

as

Begin
	
	declare @NewSubID int;

	Select top 1 @NewSubID=e.SubCategoryID
	from Test.dbo.expressions e
	inner join inserted i on i.[Description] LIKE '%' + e.Expression + '%'
	order by len(e.Expression) desc;

	update Test.dbo.transactions 
	set SubCategoryID = @NewSubID
	from Test.dbo.transactions t
	inner join inserted i on i.TransactionID = t.TransactionID

End

--FUNCTION FOR UPDATING ALL ROWS' SUBCATEGORY
--USED BY THE PROCEDURE BELOW
--IT CHECKS IF THERE IS AN EXPRESSION IN THE EXPRESSIONS TABLE THAT IS CONTAINED IN THE DESCRIPTION AND RETURNS THE ID
--IF THERE ARE MULTIPLE MATCHES IT WILL PRIORITIZE THE ONE THAT IS THE LONGEST

create function FindSubCategoryID (@Description nvarchar(200))
returns int

as begin

	DECLARE @NewSubID INT;

	SELECT TOP 1 @NewSubID =  e.SubCategoryID
	FROM Test.dbo.expressions e
	WHERE @Description LIKE '%'+ e.Expression + '%' 
	order by len(e.expression) desc

	return @NewSubID

end;

--PROCEDURE IF WE WANT TO UPDATE ALL SUBCAT IDS
--THIS USES THE FindSubCategoryID FUNCTION CREATED ABOVE

Create procedure UpdateAllSubCatID
as
begin

	SET NOCOUNT ON;

	UPDATE Test.dbo.transactions 
	SET  SUBCATEGORYID = Test.dbo.findsubcategoryID([Description])

end