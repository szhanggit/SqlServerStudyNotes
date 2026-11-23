

CREATE PROCEDURE [dbo].[spGetPreIssuedCampaignVoucher_SoftWorld]
    @ProductId INT ,
    @ReservationCodeId INT ,
    @CacheNodeId TINYINT,
	@OrderNumber VARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;

		DECLARE @True BIT = 1;
		DECLARE @False BIT = 0;

        SELECT  v.Id AS Id ,
                v.VoucherNumber AS VoucherNo ,
                v.GUID AS VoucherGuid ,
                pg.IdentityCode AS ProgramCode ,
                sw.Barcode1 AS Barcode1 ,
                sw.Barcode2 AS Barcode2 ,
                pbs.Barcode1Type AS Barcode1Type ,
                pbs.Barcode2Type AS Barcode2Type ,
                ISNULL(pbs.IsBarcode1APIEnabled, 0) AS IsBarcode1APIEnabled ,
                ISNULL(pbs.IsBarcode2APIEnabled, 0) AS IsBarcode2APIEnabled ,
                ISNULL(pbs.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText ,
                ISNULL(pbs.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText ,
                v.ShortUrl VoucherAlias,
                v.AuthCode,
                v.ExpiryDate,
                vrb.AvailableEndDate,
                v.PinCode,
				v.VoucherNumber AS Showcode,
				ISNULL(pbs.ShowcodeType,'') AS ShowcodeType,
				ISNULL(pbs.[IsShowcodeTypeDisplayText], @False) AS IsShowcodeDisplayText,
				ISNULL(pbs.[IsShowcodeTypeEnabled], @False) AS IsShowcodeAPIEnabled
        FROM    Voucher v with(readpast)
                JOIN ProductBarcodeSetting pbs WITH(NOLOCK) ON v.ProductId = pbs.Id
                JOIN VoucherReservationBatch vrb WITH(NOLOCK) ON v.ReservationBatchId = vrb.id
                JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
                JOIN Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
                JOIN EXT_TW_SoftWorld sw WITH(NOLOCK) ON v.ExtendId = sw.Id
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

