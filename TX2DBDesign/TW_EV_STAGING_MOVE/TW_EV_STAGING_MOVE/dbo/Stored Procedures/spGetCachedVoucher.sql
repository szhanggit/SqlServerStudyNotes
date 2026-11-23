CREATE PROCEDURE dbo.spGetCachedVoucher
@ProductId INT,
@AvailableStartDate varchar(50),
@AvailableEndDate varchar(50),
@ExpiryDate varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @RequireExpiryDate BIT = 0;
	SELECT @RequireExpiryDate = RequireExpiryDate FROM dbo.Product WITH(NOLOCK) WHERE Id = @ProductId;

	IF @ExpiryDate IS NULL
	BEGIN
		SELECT pv.Id, pv.BatchInfoId, pv.VoucherNumber, pv.ProgramId, pv.ProductId 
			FROM dbo.PreIssueBatchInfo pb WITH(NOLOCK)
			JOIN dbo.PreIssueVoucherInfo pv WITH(NOLOCK) ON pv.BatchInfoId = pb.Id
			JOIN dbo.VoucherReservationBatch vrb WITH(NOLOCK) ON pv.ReservationBatchId = vrb.Id
		WHERE pb.ProductId = @ProductId AND pb.Status = 256 AND pv.[Status] = 256
		AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
		AND
		(
			CASE 
				WHEN @RequireExpiryDate = 1 then pv.ExpiryDate else vrb.ExpiryDate 
			END IS NULL 
			OR 
			CASE 
				WHEN @RequireExpiryDate = 1 then pv.ExpiryDate else vrb.ExpiryDate 
			END > '2999-01-01'
		)
	END
	ELSE
	BEGIN
		SELECT pv.Id, pv.BatchInfoId, pv.VoucherNumber, pv.ProgramId, pv.ProductId
			FROM dbo.PreIssueBatchInfo pb WITH(NOLOCK)
			JOIN dbo.PreIssueVoucherInfo pv WITH(NOLOCK) ON pv.BatchInfoId = pb.Id
			JOIN dbo.VoucherReservationBatch vrb WITH(NOLOCK) ON pv.ReservationBatchId = vrb.Id
		WHERE pb.ProductId = @ProductId AND pb.Status = 256 AND pv.[Status] = 256
		AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
		AND CASE WHEN @RequireExpiryDate = 1 THEN pv.ExpiryDate ELSE vrb.ExpiryDate END = @ExpiryDate	
	END
END
