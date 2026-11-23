CREATE PROCEDURE spGetTrashVouchersInfoWithBarcodes 
	-- Add the parameters for the stored procedure here
	@BatchNo VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ProgramCode VARCHAR(20);
	DECLARE @ProgramId INT;

	SELECT @ProgramCode = IdentityCode, @ProgramId = Id FROM dbo.Program WHERE Id = 
		(SELECT ProgramId FROM dbo.Product WHERE Id = (SELECT ProductId FROM VoucherTrashBatch WHERE BatchNo = @BatchNo))

	DECLARE @prefix CHAR(1);
	DECLARE @VoucherStock VARCHAR(20);
	SELECT TOP 1 @prefix = ShortUrlPrefix, @VoucherStock = VoucherStockTableName FROM dbo.ProgramVoucherRoute WHERE ProgramId = @ProgramId;

	DECLARE @LongNumber VARCHAR(20) = CONVERT(VARCHAR(20),(ASCII(@prefix) - 48) * 100000000000000000);

	DECLARE @sql NVARCHAR(2000);

	SET @sql = 'SELECT 
					@ProgramCode AS [ProgramCode]
					,T1.VoucherNumber 
					,VEC.Barcode1
					,VEC.Barcode2
					,T5.AvailableEndDate
				FROM [dbo].[VoucherTrashBatchDetail] AS T1 WITH (NOLOCK)
				INNER JOIN [dbo].[VoucherTrashBatch] AS T2 WITH (NOLOCK) ON T1.VoucherTrashBatchId = T2.Id
				INNER JOIN [dbo].[Voucher] AS T4 WITH (NOLOCK) ON T1.VoucherId = T4.Id
				INNER JOIN [dbo].[VoucherReservationBatch] AS T5 WITH (NOLOCK) ON T5.Id = T4.ReservationBatchId
				LEFT JOIN [dbo].[VoucherExtendCode] AS VEC WITH (NOLOCK) ON T4.ExtendId = VEC.Id 
				WHERE T2.BatchNo = @BatchNo
				UNION ALL
				SELECT 
					@ProgramCode AS [ProgramCode]
					,T1.VoucherNumber 
					,Fami.Barcode1
					,Fami.Barcode2
					,T5.AvailableEndDate
				FROM [dbo].[VoucherTrashBatchDetail] AS T1 WITH (NOLOCK)
				INNER JOIN [dbo].[VoucherTrashBatch] AS T2 WITH (NOLOCK) ON T1.VoucherTrashBatchId = T2.Id
				INNER JOIN [dbo].[VoucherStock] AS T4 WITH (NOLOCK) ON T1.VoucherId - LongNumber = T4.Id
				INNER JOIN [dbo].[VoucherReservationBatch] AS T5 WITH (NOLOCK) ON T5.Id = T4.ReservationBatchId
				LEFT JOIN EXT_FamiGiftcard AS Fami ON Fami.Id = T1.VoucherId
				WHERE T2.BatchNo = @BatchNo';

	SET @sql = REPLACE(@sql,'VoucherStock',@VoucherStock);
	SET @sql = REPLACE(@sql,'LongNumber',@LongNumber);

	exec sp_executesql @sql, 
	N'@ProgramCode varchar(20),@BatchNo varchar(20)',
	@ProgramCode,@BatchNo;
END