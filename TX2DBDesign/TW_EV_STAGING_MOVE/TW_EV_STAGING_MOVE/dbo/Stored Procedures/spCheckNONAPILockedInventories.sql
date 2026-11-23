CREATE PROCEDURE [dbo].spCheckNONAPILockedInventories
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @BatchName varchar(100)
    Set @BatchName = 'CheckNONAPILockedInventories'

	DECLARE @tempSeessionId varchar(50)
	DECLARE @tempVoucherStockTableName varchar(50)
	DECLARE @sql nvarchar(800)
	DECLARE @totalCount int
	DECLARE @quantity int

	SET @totalCount = 0
	SET @quantity = 0

	DECLARE VoucherStock_Cursor CURSOR READ_ONLY FOR
	(
		SELECT vsb.SessionId,pvr.VoucherStockTableName FROM dbo.VoucherStockBook vsb with(NOLOCK) 
		INNER JOIN dbo.OrderLine ol with(NOLOCK) ON vsb.OrderLineId = ol.Id 
		INNER JOIN dbo.[Order] o with(NOLOCK) ON ol.OrderId = o.Id
		INNER JOIN dbo.ClientQuotationProduct cqp with(NOLOCK) ON ol.ClientQuotationProductId = cqp.Id
		INNER JOIN dbo.ProductVersion pv with(NOLOCK) ON cqp.ProductVersionId = pv.Id
		INNER JOIN dbo.Product p with(NOLOCK) ON pv.ProductId = p.Id
		INNER JOIN dbo.ProgramVoucherRoute pvr with(NOLOCK) ON p.ProgramId = pvr.ProgramId
		WHERE vsb.BookStatus = 0 AND vsb.CreationTime < CONVERT(VARCHAR(10),dateadd(dd,-1,getdate()),110) AND o.STATUS = 32 AND o.ExecutingStatus =3 AND o.Mode = 1
	)

	OPEN VoucherStock_Cursor
	FETCH NEXT FROM VoucherStock_Cursor INTO @tempSeessionId, @tempVoucherStockTableName

	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @sql = 'SELECT @num = COUNT(1) FROM ' + @tempVoucherStockTableName + ' with(nolock) Where StockStatus = 2 and SessionId =''' + @tempSeessionId + ''''
			Exec SP_ExecuteSQL @sql,N'@num INT Output',@quantity OUTPUT
			SET @totalCount = @totalCount + @quantity

			--IF @quantity > 0
			--	BEGIN
			--		SET @sql = 'SELECT o.OrderNumber,o.CreatedOn,o.CreatedBy FROM dbo.VoucherStockBook vsb with(NOLOCK) INNER JOIN dbo.OrderLine ol with(NOLOCK) ON vsb.OrderLineId = ol.Id INNER JOIN  dbo.[Order] o with(NOLOCK) ON o.id=ol.OrderId WHERE vsb.SessionId =''' + @tempSeessionId + ''''
			--		PRINT @sql
			--		PRINT 'UNION'
			--	END
			
			FETCH NEXT FROM VoucherStock_Cursor
			INTO @tempSeessionId, @tempVoucherStockTableName

		END

	CLOSE VoucherStock_Cursor
	DEALLOCATE VoucherStock_Cursor

	SELECT  @BatchName as [Name],@totalCount as Result
END
