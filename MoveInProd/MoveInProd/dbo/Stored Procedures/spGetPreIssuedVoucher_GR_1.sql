

CREATE PROCEDURE [dbo].[spGetPreIssuedVoucher_GR]
    @ProductId INT ,
    @ReservationCodeId INT ,
    @CacheNodeId TINYINT
AS
    BEGIN
        SET NOCOUNT ON;

		DECLARE @True BIT = 1;
		DECLARE @False BIT = 0;

        SELECT  v.Id AS Id ,
                grv.Ecode AS VoucherNo ,
                v.GUID AS VoucherGuid ,
                pg.IdentityCode AS ProgramCode ,
                v.ShortUrl VoucherAlias,
                v.AuthCode,
                v.ExpiryDate,
                vrb.AvailableEndDate,
                v.PinCode,
				'' AS Showcode,
				'' AS ShowcodeType,
				@False AS IsShowcodeDisplayText,
				@False AS IsShowcodeAPIEnabled
        FROM    Voucher v with(readpast)
		JOIN dbo.EXT_GR_VoucherInfo AS grv WITH(NOLOCK) ON grv.Id = v.ExtendId
                JOIN VoucherReservationBatch vrb WITH(NOLOCK) ON v.ReservationBatchId = vrb.id
                JOIN Product p WITH(NOLOCK) ON v.ProductId = p.Id
                JOIN Program pg WITH(NOLOCK) ON p.ProgramId = pg.Id
        WHERE   v.ProductId = @ProductId
                AND v.CacheNode = @CacheNodeId
                AND v.Status = 256
                AND v.BeneficiaryInfoId IS NULL
                AND p.Status = 1
                AND vrb.VoucherReservationCodeId = @ReservationCodeId
    END

