
CREATE PROCEDURE [dbo].[spUpdateReservationBatchAvailableDate]
@SourceBatchNumbers VARCHAR(MAX),
@DestBatchNumbers VARCHAR(MAX),
@AvailableStartDate INT,
@AvailableEndDate INT,
@ExpiryDate DATETIME
AS
BEGIN
	IF (@SourceBatchNumbers IS NULL OR @SourceBatchNumbers = '' OR @DestBatchNumbers IS NULL OR @DestBatchNumbers = '') RETURN;

	DECLARE @T1 TABLE (Position INT, [Value] VARCHAR(MAX))
	INSERT INTO @T1 SELECT * FROM F_SplitString(@SourceBatchNumbers, '|') WHERE [Value] <> ''
	
	DECLARE @T2 TABLE (Position INT, [Value] VARCHAR(MAX))
	INSERT INTO @T2 SELECT * FROM F_SplitString(@DestBatchNumbers, '|') WHERE [Value] <> ''
	
	IF ((SELECT COUNT(1) FROM @T1) <> (SELECT COUNT(2) FROM @T2)) RETURN;
	
	-- Query Voucher Stock Table Name
	DECLARE @VoucherStockTableName varchar(255)
	SELECT @VoucherStockTableName = R.VoucherStockTableName
	FROM VoucherReservationBatch B
	INNER JOIN Product P ON B.ProductId = P.Id
	INNER JOIN Program PG ON P.ProgramId = PG.Id
	INNER JOIN ProgramVoucherRoute R ON PG.Id = R.ProgramId
	WHERE B.BatchNo = (SELECT [Value] FROM @T1 WHERE Position = 1)
	
	-- Prepare update in-stock vouchers SQL Statement
	DECLARE @SQLStatement NVARCHAR(MAX) = N'UPDATE {0}
		SET
			ReservationBatchId = @DestBatchId,
			ExpiryDate = @ExpiryDate
		FROM VoucherReservationBatch B
		WHERE B.Id = {0}.ReservationBatchId 
		AND B.ProductId = {0}.ProductId 
		AND {0}.StockStatus = 0
		AND B.Id = @SourceBatchId'
	
	SET @SQLStatement = REPLACE(@SQLStatement, N'{0}', @VoucherStockTableName)
	
	BEGIN TRAN
	BEGIN TRY
		DECLARE @Position INT = 1;
		
		WHILE EXISTS(SELECT 1 FROM @T1 WHERE Position = @Position)
		BEGIN
			DECLARE @SourceBatchNumber VARCHAR(50) = (SELECT [Value] FROM @T1 WHERE Position = @Position)
			DECLARE @SourceBatchId INT = (SELECT Id FROM VoucherReservationBatch WHERE BatchNo = @SourceBatchNumber)
			DECLARE @DestBatchNumber VARCHAR(50) = (SELECT [Value] FROM @T2 WHERE Position = @Position)
			DECLARE @DestBatchId INT = (SELECT Id FROM VoucherReservationBatch WHERE BatchNo = @DestBatchNumber)
			DECLARE @VoucherCount INT = 0
			
			-- Update reservation batch id and expiry date of cached vouchers
			UPDATE Voucher
			SET
				ExpiryDate = @ExpiryDate,
				ReservationBatchId = @DestBatchId
			FROM VoucherReservationBatch B
			WHERE B.Id = Voucher.ReservationBatchId AND B.ProductId = Voucher.ProductId AND Voucher.Status = 64
			AND B.Id = @SourceBatchId
			
			-- Update reservation batch id and expiry date of in-stock vouchers
			EXECUTE sp_executesql @SQLStatement, N'@SourceBatchId INT, @DestBatchId INT, @ExpiryDate DATETIME', 
				@SourceBatchId = @SourceBatchId, @DestBatchId = @DestBatchId, @ExpiryDate = @ExpiryDate
			
			SET @VoucherCount = @VoucherCount + @@ROWCOUNT
			
			-- Reduce voucher count of source reservation batch
			UPDATE VoucherReservationBatch SET VoucherCount = VoucherCount - @VoucherCount
			WHERE Id = @SourceBatchId
			
			-- Increase voucher count of destination reservatch batch
			UPDATE VoucherReservationBatch SET VoucherCount = VoucherCount + @VoucherCount
			WHERE Id = @DestBatchId
			
			SET @Position = @Position + 1
		END
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH
END
