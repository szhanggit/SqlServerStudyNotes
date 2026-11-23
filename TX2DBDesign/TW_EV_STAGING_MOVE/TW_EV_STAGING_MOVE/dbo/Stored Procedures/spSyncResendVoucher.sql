
CREATE PROCEDURE dbo.spSyncResendVoucher @batchId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
	BEGIN TRAN
		UPDATE bv SET bv.ResponeCode = IIF(bv.Email IS NULL, v.DistributionSLMSStatus, v.DistributionEmailStatus)
			FROM dbo.CSSResendBatchVoucher bv WITH(NOLOCK)
			JOIN dbo.Voucher v WITH(NOLOCK) ON v.Id = bv.VoucherId
			WHERE bv.BatchId = @batchId AND bv.Comment IS NULL;
		
		UPDATE dbo.CSSResendBatchVoucher SET ResponeCode = CASE ResponeCode WHEN '3' THEN '0000' WHEN '4' THEN '0006' ELSE ResponeCode END,
			ResponeMessage = CASE ResponeCode WHEN '3' THEN 'Resent Success' WHEN '4' THEN 'Sent Failed - Service Provider return error' ELSE ResponeMessage END
			WHERE BatchId = @batchId;

		UPDATE b SET 
				b.[Status] = IIF(t.sc = b.TotalCount - t.skipCount, 2, IIF(b.ExecuteEndTime < DATEADD(MINUTE, -120, GETDATE()), 2, b.[Status])), 
				b.SuccessCount = t.sc, 
				b.FailCount = t.fc
			FROM dbo.CSSResendBatch b
			JOIN (SELECT @batchId BatchId, SUM(IIF(ResponeCode = '0000', 1 , 0)) sc, SUM(IIF(ResponeCode = '0000', 0 , 1)) fc, COUNT(Comment) skipCount FROM dbo.CSSResendBatchVoucher WHERE BatchId = @batchId) t ON t.BatchId = b.Id
			WHERE b.Id = @batchId;

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END
