

CREATE PROCEDURE [dbo].[spGetPreIssuedCampaignVoucher_HiLife]
	@ProductId INT,
	@ReservationCodeId INT,
	@CacheNodeId TINYINT,
	@OrderNumber VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @True BIT = 1;
	DECLARE @False BIT = 0;

	SELECT
		v.Id AS Id,
		v.VoucherNumber AS VoucherNo,
		v.GUID AS VoucherGuid,
		pg.IdentityCode AS ProgramCode,
		ISNULL(vec.Barcode1,'') AS Barcode1,
		ISNULL(vec.Barcode2,'') AS Barcode2,
		ISNULL(vec.Barcode3,'') AS Barcode3,
		ISNULL(vec.Barcode4,'') AS Barcode4,
		ISNULL(pbs.Barcode1Type,'') AS Barcode1Type,
		ISNULL(pbs.Barcode2Type,'') AS Barcode2Type,
		ISNULL(pbs.Barcode3Type,'') AS Barcode3Type,
		ISNULL(pbs.Barcode4Type,'') AS Barcode4Type,
		ISNULL(pbs.IsBarcode1APIEnabled, @False) AS IsBarcode1APIEnabled,
		ISNULL(pbs.IsBarcode2APIEnabled, @False) AS IsBarcode2APIEnabled,
		ISNULL(pbs.IsBarcode3APIEnabled, @False) AS IsBarcode3APIEnabled,
		ISNULL(pbs.IsBarcode4APIEnabled, @False) AS IsBarcode4APIEnabled,
		ISNULL(pbs.IsBarcode1DisplayText, @False) AS IsBarcode1DisplayText,
		ISNULL(pbs.IsBarcode2DisplayText, @False) AS IsBarcode2DisplayText,
		ISNULL(pbs.IsBarcode3DisplayText, @False) AS IsBarcode3DisplayText,
		ISNULL(pbs.IsBarcode4DisplayText, @False) AS IsBarcode4DisplayText,
		v.ShortUrl VoucherAlias,
		v.AuthCode,
		v.ExpiryDate,
		vrb.AvailableEndDate,
		v.PinCode,
		v.VoucherNumber AS Showcode,
		ISNULL(pbs.ShowcodeType,'') AS ShowcodeType,
		ISNULL(pbs.[IsShowcodeTypeDisplayText], @False) AS IsShowcodeDisplayText,
		ISNULL(pbs.[IsShowcodeTypeEnabled], @False) AS IsShowcodeAPIEnabled
	FROM Voucher v with(readpast)
		JOIN ProductBarcodeSetting pbs WITH(NOLOCK) ON v.ProductId = pbs.Id
		JOIN VoucherReservationBatch vrb WITH(NOLOCK) ON v.ReservationBatchId = vrb.id
		JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
		JOIN Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
		LEFT JOIN VoucherExtendCode vec WITH(NOLOCK) ON v.Id = vec.Id
		LEFT JOIN PreIssuedCampaignVoucher pcv  WITH(NOLOCK) ON pcv.VoucherId = v.Id
		JOIN PreIssuedCampaignVoucherRequestInfo picoi WITH(NOLOCK) ON picoi.OrderBeneficiaryInfoId = v.BeneficiaryInfoId AND p.ProductCode = picoi.ProductCode
	WHERE v.ProductId = @ProductId
		AND v.CacheNode = @CacheNodeId
		AND v.Status = 2
		AND p.Status = 1
		AND vrb.VoucherReservationCodeId = @ReservationCodeId
		AND pcv.VoucherId is NULL
		AND picoi.OrderNumber = @OrderNumber
		AND picoi.ProcessStatus = 2
		AND picoi.TrashDate > getdate()
		Order By v.Id
END

