
--STORED PROCEDURE TO INSERT A NEW TRANSACTION INTO THE TRANSACTION TABLE WITH FOR EXAMPLE A PYTHON CODE
--AFTER THE INSERT, THE CODE TRIES TO FIND THE SUBCATEGORY ID BASED ON THE EXPRESSION TABLE

CREATE PROCEDURE InsertUpdateTransactions
(@Owner  NVARCHAR(50),
@Date  DATE,
@Description   NVARCHAR(200),
@Amount DECIMAL(20,2)
)
AS

BEGIN

	SET NOCOUNT ON;

	INSERT INTO Test.dbo.transactions ([OWNER],[DATE],[Description],[Amount])
	VALUES (@Owner, @Date, @Description, @Amount)


	DECLARE @NewSubID INT;

	SELECT TOP 1 @NewSubID =  e.SubCategoryID
	FROM Test.dbo.expressions e
	WHERE @Description LIKE '%'+ e.Expression + '%' 
	ORDER BY len(e.expression) DESC

	UPDATE Test.dbo.transactions 
	SET SUBCATEGORYID = @NewSubId
	WHERE TransactionID=SCOPE_IDENTITY();

END;

--CREATING THE SAME AUTOMATION WITH TRIGGER FOR PRACTICE
--IF THERE IS A NEW TRANSACTION INSERTED IN THE TRANSACTIONS TABLE, IT TRIES TO FIND THE SUBCATEGORY ID IN THE EXPRESSION TABLE

CREATE TRIGGER SubCategoryUpdate ON
Test.dbo.transactions AFTER INSERT

AS

BEGIN
	
	DECLARE @NewSubID INT;

	SELECT TOP 1 @NewSubID=e.SubCategoryID
	FROM Test.dbo.expressions e
	INNER JOIN inserted i ON i.[Description] LIKE '%' + e.Expression + '%'
	ORDER BY len(e.Expression) DESC;

	UPDATE Test.dbo.transactions 
	SET SubCategoryID = @NewSubID
	FROM Test.dbo.transactions t
	INNER JOIN inserted i ON i.TransactionID = t.TransactionID

END

--FUNCTION FOR UPDATING ALL ROWS' SUBCATEGORY
--USED BY THE PROCEDURE BELOW
--IT CHECKS IF THERE IS AN EXPRESSION IN THE EXPRESSIONS TABLE THAT IS CONTAINED IN THE DESCRIPTION AND RETURNS THE ID
--IF THERE ARE MULTIPLE MATCHES IT WILL PRIORITIZE THE ONE THAT IS THE LONGEST

CREATE FUNCTION FindSubCategoryID (@Description NVARCHAR(200))
RETURNS INT

AS BEGIN

	DECLARE @NewSubID INT;

	SELECT TOP 1 @NewSubID =  e.SubCategoryID
	FROM Test.dbo.expressions e
	WHERE @Description LIKE '%'+ e.Expression + '%' 
	ORDER BY len(e.expression) DESC

	RETURN @NewSubID

END;

--PROCEDURE IF WE WANT TO UPDATE ALL SUBCAT IDS
--THIS USES THE FindSubCategoryID FUNCTION CREATED ABOVE

CREATE PROCEDURE UpdateAllSubCatID
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE Test.dbo.transactions 
	SET  SUBCATEGORYID = Test.dbo.findsubcategoryID([Description])

END