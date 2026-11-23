

CREATE PROCEDURE [dbo].[spGetPreIssuedVoucher_FamilyMart]
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
                ISNULL(fm.Barcode1,'') AS Barcode1 ,
                ISNULL(fm.Barcode2,'') AS Barcode2 ,
                ISNULL(fm.Barcode3,'') AS Barcode3 ,
                ISNULL(fm.Barcode4,'') AS Barcode4 ,
                ISNULL(pbs.Barcode1Type,'') AS Barcode1Type ,
                ISNULL(pbs.Barcode2Type,'') AS Barcode2Type ,
                ISNULL(pbs.Barcode3Type,'') AS Barcode3Type ,
                ISNULL(pbs.Barcode4Type,'') AS Barcode4Type ,
                ISNULL(pbs.IsBarcode1APIEnabled, 0) AS IsBarcode1APIEnabled ,
                ISNULL(pbs.IsBarcode2APIEnabled, 0) AS IsBarcode2APIEnabled ,				
                ISNULL(pbs.IsBarcode3APIEnabled, 0) AS IsBarcode3APIEnabled ,
                ISNULL(pbs.IsBarcode4APIEnabled, 0) AS IsBarcode4APIEnabled ,
                ISNULL(pbs.IsBarcode1DisplayText, 0) AS IsBarcode1DisplayText ,
                ISNULL(pbs.IsBarcode2DisplayText, 0) AS IsBarcode2DisplayText ,				
                ISNULL(pbs.IsBarcode3DisplayText, 0) AS IsBarcode3DisplayText ,
                ISNULL(pbs.IsBarcode4DisplayText, 0) AS IsBarcode4DisplayText ,
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
                LEFT JOIN EXT_TW_FamilyMart fm WITH(NOLOCK) ON v.ExtendId = fm.Id
        WHERE   v.ProductId = @ProductId
                AND v.CacheNode = @CacheNodeId
                AND v.Status = 256
                AND v.BeneficiaryInfoId IS NULL
                AND p.Status = 1
                AND vrb.VoucherReservationCodeId = @ReservationCodeId
    END

