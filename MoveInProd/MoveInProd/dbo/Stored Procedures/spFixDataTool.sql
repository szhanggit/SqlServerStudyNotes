
CREATE PROCEDURE [dbo].[spFixDataTool]
@DateNum INT
AS
BEGIN
	SET NOCOUNT ON;
		IF EXISTS (SELECT 1 
			   FROM INFORMATION_SCHEMA.TABLES 
			   WHERE TABLE_TYPE='BASE TABLE' 
			   AND TABLE_NAME='TransactionNWR') 
		BEGIN
			DROP TABLE [TransactionNWR]
		END


		IF EXISTS (SELECT 1 
			   FROM INFORMATION_SCHEMA.TABLES 
			   WHERE TABLE_TYPE='BASE TABLE' 
			   AND TABLE_NAME='TransactionNWRCalcu') 
		BEGIN
			DROP TABLE [TransactionNWRCalcu]
		END	
-------------------------------
	DECLARE @index INT = 0;
	SELECT TOP (1) @index = Id FROM dbo.[Transaction] WITH(NOLOCK) WHERE [TranLocalDate] = @DateNum ORDER BY Id
	WHILE exists (SELECT * FROM dbo.[Transaction] WITH(NOLOCK) WHERE [TranLocalDate] = @DateNum AND id >= @index AND id<(@index+3000))
	BEGIN
	SELECT * INTO TransactionNWR FROM dbo.[Transaction] WITH(NOLOCK) WHERE [TranLocalDate] = @DateNum AND id >= @index AND id<(@index+3000)
	-------------------
	EXEC spDataFixingPreparing;
	EXEC spFixData;
	-------------------
		IF EXISTS (SELECT 1 
			   FROM INFORMATION_SCHEMA.TABLES 
			   WHERE TABLE_TYPE='BASE TABLE' 
			   AND TABLE_NAME='TransactionNWR') 
		BEGIN
			DROP TABLE [TransactionNWR]
		END


		IF EXISTS (SELECT 1 
			   FROM INFORMATION_SCHEMA.TABLES 
			   WHERE TABLE_TYPE='BASE TABLE' 
			   AND TABLE_NAME='TransactionNWRCalcu') 
		BEGIN
			DROP TABLE [TransactionNWRCalcu]
		END
	SET @index = @index + 3000;
	end	
-------------------------------
END
