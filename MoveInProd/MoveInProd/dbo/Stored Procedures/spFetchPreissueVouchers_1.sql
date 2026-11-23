
CREATE PROCEDURE [dbo].[spFetchPreissueVouchers] @ProductId INT
	,@CacheNode TINYINT
	,@Count INT
	,@ReservationCodeId INT
	,@ExpirationDateStart DATETIME
	,@ExpirationDateEnd DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDate INT
	SET @CurrentDate = CAST(convert(varchar,getdate(),112) as int)

	BEGIN TRAN

	IF EXISTS(SELECT * FROM dbo.Product WITH(NOLOCK) WHERE Id = @ProductId AND RequireExpiryDate = 0)
	BEGIN
		UPDATE TOP (@Count) V
		SET [STATUS] = 128
			,[CacheNode] = @CacheNode
		FROM [dbo].[Voucher] V JOIN [dbo].[VoucherReservationBatch] VRB ON V.ReservationBatchId=VRB.ID
		WHERE V.[BeneficiaryInfoId] IS NULL
			AND V.[CacheNode] IS NULL
			AND V.[Status] = 64
			AND V.[ProductId] = @ProductId
			AND VRB.VoucherReservationCodeId = @ReservationCodeId
			AND @CurrentDate >= VRB.AvailableStartDate
			AND VRB.AvailableEndDate >= @CurrentDate
	END
	ELSE
	BEGIN
		update vt
		SET [STATUS] = 128
		,[CacheNode] = @CacheNode
		FROM (select  ROW_NUMBER()OVER(Order By v.ExpiryDate)As OrderLineSN	, v.Status AS [STATUS], v.CacheNode 
					FROM [dbo].[Voucher] V JOIN [dbo].[VoucherReservationBatch] VRB ON V.ReservationBatchId=VRB.ID
					WHERE V.[BeneficiaryInfoId] IS NULL
					AND V.[CacheNode] IS NULL
					AND V.[Status] = 64
					AND V.[ProductId] = @ProductId
					AND VRB.VoucherReservationCodeId = @ReservationCodeId
					AND @CurrentDate >= VRB.AvailableStartDate
					AND VRB.AvailableEndDate >= @CurrentDate
					AND v.ExpiryDate >= @ExpirationDateStart
					AND v.ExpiryDate < @ExpirationDateEnd) vt 
		where OrderLineSN <= @Count 
	END

	IF @@ERROR <> 0
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN
END
