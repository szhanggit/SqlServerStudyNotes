
CREATE PROCEDURE [dbo].[spGetPreIssuedCampaignVoucher_IQiYi] 
	@ProductId INT ,
    @ReservationCodeId INT ,
    @CacheNodeId TINYINT,
	@OrderNumber VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

		declare @true bit = 1;
		declare @false bit = 0;

        SELECT  v.Id AS Id ,
                v.VoucherNumber AS VoucherNo ,
                v.GUID AS VoucherGuid ,
                pg.IdentityCode AS ProgramCode ,
                seb.ActivationCode AS Barcode1 ,
				'Code128A' Barcode1Type,
				@true IsBarcode1APIEnabled ,
                @true IsBarcode1DisplayText ,
                v.ShortUrl VoucherAlias,
                v.AuthCode,
				v.ExpiryDate,
				vrb.AvailableEndDate,
				'' AS Showcode,
				'' AS ShowcodeType,
				@false AS IsShowcodeDisplayText,
				@false AS IsShowcodeAPIEnabled
        FROM    Voucher v with(readpast)
                JOIN VoucherReservationBatch vrb WITH(NOLOCK) ON v.ReservationBatchId = vrb.id
                JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
                JOIN Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
                JOIN EXT_TW_IQiYi seb WITH(NOLOCK) ON v.ExtendId = seb.Id
				LEFT JOIN PreIssuedCampaignVoucher pcv  WITH(NOLOCK) ON pcv.VoucherId = v.Id
				JOIN PreIssuedCampaignVoucherRequestInfo picoi WITH(NOLOCK) ON picoi.OrderBeneficiaryInfoId = v.BeneficiaryInfoId AND p.ProductCode = picoi.ProductCode
        WHERE   v.ProductId = @ProductId
                AND v.CacheNode = @CacheNodeId
                AND v.Status = 2
                AND p.Status = 1
                AND vrb.VoucherReservationCodeId = @ReservationCodeId
				AND pcv.VoucherId is NULL
				AND picoi.OrderNumber = @OrderNumber
				AND picoi.ProcessStatus = 2
    END

