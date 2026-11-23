
CREATE PROCEDURE [dbo].[spCountReservationCode] @productId INT
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT * FROM dbo.Product WITH(NOLOCK) WHERE RequireExpiryDate = 1 AND Id = @productId)
	BEGIN
		SELECT c.ReservationCode
			,SUM(IIF(v.BeneficiaryInfoId IS NULL AND v.STATUS = 64, 1, 0)) AS [Count]
			,b.ExpiryDate
			,SUM(IIF(v.BeneficiaryInfoId IS NULL AND v.STATUS = 256, 1, 0)) AS [CacheCount]
			,b.AvailableStartDate
			,b.AvailableEndDate
		FROM Voucher v
		  JOIN VoucherReservationBatch b ON v.ReservationBatchId = b.Id
		  JOIN VoucherReservationCode c ON b.VoucherReservationCodeId = c.Id
		WHERE v.ProductId = @productId AND (v.Status = 64 OR v.STATUS = 256)
		GROUP BY c.ReservationCode,b.ExpiryDate, b.AvailableStartDate, b.AvailableEndDate
	END
	ELSE
	BEGIN
		SELECT c.ReservationCode
			,SUM(IIF(v.BeneficiaryInfoId IS NULL AND v.STATUS = 64, 1, 0)) AS [Count]
			,v.ExpiryDate
			,SUM(IIF(v.BeneficiaryInfoId IS NULL AND v.STATUS = 256, 1, 0)) AS [CacheCount]
			,b.AvailableStartDate
			,b.AvailableEndDate
		FROM Voucher v
		  JOIN VoucherReservationBatch b ON v.ReservationBatchId = b.Id
		  JOIN VoucherReservationCode c ON b.VoucherReservationCodeId = c.Id
		WHERE v.ProductId = @productId AND  (v.Status = 64 OR v.STATUS = 256)
		GROUP BY c.ReservationCode,v.ExpiryDate, b.AvailableStartDate, b.AvailableEndDate
	END
END
