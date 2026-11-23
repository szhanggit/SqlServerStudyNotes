

CREATE PROCEDURE [dbo].[spGetPreIssuedVoucher_Starbucks]
    @ProductId INT ,
    @ReservationCodeId INT ,
    @CacheNodeId TINYINT
AS
    BEGIN
        SET NOCOUNT ON;

		DECLARE @True BIT = 1;
		DECLARE @False BIT = 0;

        SELECT  v.Id AS Id ,
                v.VoucherNumber AS VoucherNo ,
                v.GUID AS VoucherGuid ,
                pg.IdentityCode AS ProgramCode ,
                sbk.QRCode AS Barcode1 ,
                pbs.Barcode1Type AS Barcode1Type ,
                ISNULL(pbs.IsBarcode1APIEnabled, 0) AS IsBarcode1APIEnabled ,
                ISNULL(pbs.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText ,
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
                JOIN EXT_TW_Starbucks sbk WITH(NOLOCK) ON v.ExtendId = sbk.Id
        WHERE   v.ProductId = @ProductId
                AND v.CacheNode = @CacheNodeId
                AND v.Status = 256
                AND v.BeneficiaryInfoId IS NULL
                AND p.Status = 1
                AND vrb.VoucherReservationCodeId = @ReservationCodeId
    END

