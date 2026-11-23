
-- Stored Procedure

CREATE PROCEDURE [dbo].[spGetTrashVouchersInfo]
    @BatchNo VARCHAR(20)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

		SELECT 
			T6.IdentityCode AS [ProgramCode]
			,T1.VoucherNumber 
			,T5.AvailableEndDate
		FROM [dbo].[VoucherTrashBatchDetail] AS T1
		INNER JOIN [dbo].[VoucherTrashBatch] AS T2 ON T1.VoucherTrashBatchId = T2.Id
		INNER JOIN [dbo].[Voucher] AS T4 ON T1.VoucherId = T4.Id
		INNER JOIN [dbo].[VoucherReservationBatch] AS T5 ON T5.Id = T4.ReservationBatchId
		INNER JOIN [dbo].[Program] AS T6 ON T4.ProgramId = T6.Id
		WHERE T2.BatchNo = @BatchNo

    END

