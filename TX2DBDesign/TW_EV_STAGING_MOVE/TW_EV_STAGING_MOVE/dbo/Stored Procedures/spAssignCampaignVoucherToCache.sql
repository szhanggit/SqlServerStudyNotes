
CREATE PROCEDURE [dbo].[spAssignCampaignVoucherToCache]
    @ProductId INT ,
    @ReservationCodeId INT ,
    @CacheNodeId TINYINT , 
	@OrderNumber VARCHAR(50),
	@Count INT,
	@Session VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

		UPDATE TOP(@Count) v SET v.CacheNode = @CacheNodeId,v.VSessionId = @Session
		FROM Voucher v
		JOIN VoucherReservationBatch vrb WITH(NOLOCK) ON v.ReservationBatchId = vrb.id
        JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
		LEFT JOIN PreIssuedCampaignVoucher pcv  WITH(NOLOCK) ON pcv.VoucherId = v.Id
		JOIN PreIssuedCampaignVoucherRequestInfo picoi WITH(NOLOCK) ON picoi.OrderBeneficiaryInfoId = v.BeneficiaryInfoId AND p.ProductCode = picoi.ProductCode
		WHERE   v.ProductId = @ProductId
                AND v.CacheNode IS NULL
                AND v.Status = 2
                AND p.Status = 1
                AND vrb.VoucherReservationCodeId = @ReservationCodeId
				AND pcv.VoucherId is NULL
				AND picoi.OrderNumber = @OrderNumber
				AND picoi.ProcessStatus = 2
    END
