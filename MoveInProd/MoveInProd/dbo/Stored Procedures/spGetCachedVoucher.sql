
CREATE PROCEDURE dbo.spGetCachedVoucher 
@ProductId INT,
@AvailableStartDate varchar(50),
@AvailableEndDate varchar(50),
@ExpiryDate varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	if @ExpiryDate is null
	begin
		select p.IdentityCode, v.VoucherNumber from Voucher v with(nolock) 
		inner join Program p with(nolock) on v.ProgramId = p.Id
		inner join VoucherReservationBatch vrb with(nolock) on v.ReservationBatchId = vrb.Id
		inner join Product pd with(nolock) on v.ProductId = pd.Id
		where v.ProductId = @ProductId AND v.[Status] = 256
		AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
		AND (case when pd.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end is null OR case when pd.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end > '2999-01-01')	
	
	end
	else
	begin
		select p.IdentityCode, v.VoucherNumber from Voucher v with(nolock) 
		inner join Program p with(nolock) on v.ProgramId = p.Id
		inner join VoucherReservationBatch vrb with(nolock) on v.ReservationBatchId = vrb.Id
		inner join Product pd with(nolock) on v.ProductId = pd.Id
		where v.ProductId = @ProductId AND v.[Status] = 256
		AND vrb.AvailableStartDate = @AvailableStartDate AND vrb.AvailableEndDate = @AvailableEndDate
		AND case when pd.RequireExpiryDate = 1 then v.ExpiryDate else vrb.ExpiryDate end = @ExpiryDate	
	end
END
