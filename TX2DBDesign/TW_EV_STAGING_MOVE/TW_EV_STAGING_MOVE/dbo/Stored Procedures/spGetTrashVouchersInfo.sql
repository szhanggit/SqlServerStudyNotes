-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetTrashVouchersInfo 
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
	SELECT @prefix = ShortUrlPrefix, @VoucherStock = VoucherStockTableName FROM dbo.ProgramVoucherRoute WHERE Id = @ProgramId;

	DECLARE @LongNumber VARCHAR(20) = CONVERT(VARCHAR(20),(ASCII(@prefix) - 48) * 100000000000000000);

	DECLARE @sql NVARCHAR(2000);

	SET @sql = 'SELECT 
					@ProgramCode AS [ProgramCode]
					,T1.VoucherNumber 
					,T5.AvailableEndDate
				FROM [dbo].[VoucherTrashBatchDetail] AS T1
				INNER JOIN [dbo].[VoucherTrashBatch] AS T2 ON T1.VoucherTrashBatchId = T2.Id
				INNER JOIN [dbo].[Voucher] AS T4 WITH (NOLOCK) ON T1.VoucherId = T4.Id
				INNER JOIN [dbo].[VoucherReservationBatch] AS T5 ON T5.Id = T4.ReservationBatchId
				WHERE T2.BatchNo = @BatchNo
				UNION ALL
				SELECT 
					@ProgramCode AS [ProgramCode]
					,T1.VoucherNumber 
					,T5.AvailableEndDate
				FROM [dbo].[VoucherTrashBatchDetail] AS T1
				INNER JOIN [dbo].[VoucherTrashBatch] AS T2 ON T1.VoucherTrashBatchId = T2.Id
				INNER JOIN [dbo].[VoucherStock] AS T4 WITH (NOLOCK) ON T1.VoucherId - LongNumber = T4.Id
				INNER JOIN [dbo].[VoucherReservationBatch] AS T5 ON T5.Id = T4.ReservationBatchId
				WHERE T2.BatchNo = @BatchNo';

	SET @sql = REPLACE(@sql,'VoucherStock',@VoucherStock);
	SET @sql = REPLACE(@sql,'LongNumber',@LongNumber);

	exec sp_executesql @sql, 
	N'@ProgramCode varchar(20),@BatchNo varchar(20)',
	@ProgramCode,@BatchNo;
END
