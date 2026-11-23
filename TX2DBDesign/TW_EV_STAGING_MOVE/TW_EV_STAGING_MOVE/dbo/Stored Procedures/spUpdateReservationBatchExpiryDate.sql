CREATE PROCEDURE spUpdateReservationBatchExpiryDate
@BatchNumbers VARCHAR(MAX),
@ExpiryDate DATETIME
AS
BEGIN
	IF (@BatchNumbers IS NULL OR @BatchNumbers = '') RETURN;

	DECLARE @T TABLE (Position INT, [Value] VARCHAR(MAX))
	INSERT INTO @T SELECT * FROM F_SplitString(@BatchNumbers, '|') WHERE [Value] <> ''

	BEGIN TRAN
	BEGIN TRY
		-- Update VoucherReservationBatch.ExpiryDate
		UPDATE VoucherReservationBatch 
		SET
			ExpiryDate = @ExpiryDate
		WHERE BatchNo IN (SELECT [Value] FROM @T)	

		IF (@@ROWCOUNT <> (SELECT COUNT(1) FROM @T))
		BEGIN
			ROLLBACK TRAN;
			RETURN;
		END

		-- Update Voucher.ExpiryDate (cached vouchers)
		UPDATE Voucher
		SET ExpiryDate = @ExpiryDate
		FROM VoucherReservationBatch B
		WHERE B.Id = Voucher.ReservationBatchId AND B.ProductId = Voucher.ProductId AND Voucher.Status = 256
		AND B.BatchNo IN (SELECT [Value] FROM @T)

		-- Query Voucher Stock Table Name
		DECLARE @VoucherStockTableName varchar(255)
		SELECT @VoucherStockTableName = R.VoucherStockTableName
		FROM VoucherReservationBatch B
		INNER JOIN Product P ON B.ProductId = P.Id
		INNER JOIN Program PG ON P.ProgramId = PG.Id
		INNER JOIN ProgramVoucherRoute R ON PG.Id = R.ProgramId
		WHERE B.BatchNo = (SELECT [Value] FROM @T WHERE Position = 1)

		-- Prepare SQL Statement
		DECLARE @SQLStatement VARCHAR(MAX) = 'UPDATE {0}
			SET ExpiryDate = @ExpiryDate
			FROM VoucherReservationBatch B
			WHERE B.Id = VoucherStock_W.ReservationBatchId 
			AND B.ProductId = {0}.ProductId 
			AND {0}.StockStatus = 0
			AND B.BatchNo IN (SELECT [Value] FROM @T)'

		SET @SQLStatement = REPLACE(@SQLStatement, '{0}', @VoucherStockTableName)

		-- Update VoucherStock.ExpiryDate (in-stock vouchers)
		EXECUTE sp_executesql @SQLStatement
		
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
	END CATCH
END