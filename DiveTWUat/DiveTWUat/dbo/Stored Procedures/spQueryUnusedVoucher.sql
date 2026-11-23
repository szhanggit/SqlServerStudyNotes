
CREATE PROCEDURE [dbo].[spQueryUnusedVoucher]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50)
AS
    BEGIN

        DECLARE @Id BIGINT

        UPDATE TOP ( 1 )
                dbo.Voucher
        SET     Status = 1 ,
                @Id = Id ,
                RequestId = @RequestId
        WHERE   Status = 0
                AND RequestId IS NULL
                AND VendorCode = @VendorCode
                AND ProductCode = @ProductCode
                AND ProgramCode = @ProgramCode

        IF @@ROWCOUNT > 0
            BEGIN
                SELECT  VoucherNumber AS TPCVoucherNumber ,
                        ExpiryDate AS TPCExpriyDate ,
                        Amount ,
                        CurrencyCode ,
                        Misc1 ,
                        Misc2 ,
                        Misc3 ,
                        Password
                FROM    dbo.Voucher
                WHERE   Id = @Id
            END
    END

