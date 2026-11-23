
-- Stored Procedure

CREATE PROCEDURE [dbo].[spGetPreIssuedVouchersForTrash]
    @ProductId INT 
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
		DECLARE @CurrentDate INT
		SET @CurrentDate = CONVERT(INT,CONVERT(VARCHAR(100),DATEADD(DAY,-1,GETDATE()), 112))

        SELECT T1.VoucherNumber
        FROM    dbo.Voucher AS T1
			INNER JOIN [dbo].[VoucherReservationBatch] AS T2 ON T1.ReservationBatchId = T2.Id
        WHERE   T1.ProductId = @ProductId
			AND T2.AvailableEndDate = @CurrentDate
            AND T1.[Status] = 256
    END

