
CREATE PROCEDURE [dbo].[spInsertCadoozVoucher]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @Code NVARCHAR(500) ,
    @Currency NVARCHAR(500) ,
    @ECardLink NVARCHAR(500) ,
    @EVoucherLink NVARCHAR(500) ,
    @Pin NVARCHAR(500) ,
    @ProductName NVARCHAR(500) ,
    @ProductNumber NVARCHAR(500) ,
    @ProductVariationNumber NVARCHAR(500) ,
    @SerialNumber BIGINT ,
    @Value NUMERIC(20, 6) ,
    @Email NVARCHAR(500) ,
    @OrderNumber NVARCHAR(500) ,
    @CreatedOn DATETIME ,
    @Status TINYINT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @VoucherId BIGINT
        DECLARE @CadoozVoucherId BIGINT
        INSERT  INTO dbo.CadoozVoucher
                ( ProgramCode ,
                  VendorCode ,
                  VoucherId ,
                  Code ,
                  Currency ,
                  ECardLink ,
                  EVoucherLink ,
                  Pin ,
                  ProductName ,
                  ProductNumber ,
                  ProductVariationNumber ,
                  SerialNumber ,
                  Value ,
                  Email ,
                  OrderNumber ,
                  TPCLogId
                )
        VALUES  ( @ProgramCode ,
                  @VendorCode ,
                  NULL ,
                  @Code ,
                  @Currency ,
                  @ECardLink ,
                  @EVoucherLink ,
                  @Pin ,
                  @ProductName ,
                  @ProductNumber ,
                  @ProductVariationNumber ,
                  @SerialNumber ,
                  @Value ,
                  @Email ,
                  @OrderNumber ,
                  @TPCLogId
                )
        SELECT  @CadoozVoucherId = SCOPE_IDENTITY()

        BEGIN TRAN

        BEGIN TRY

            UPDATE  dbo.Voucher
            SET     @VoucherId = Id ,
                    VoucherNumber = @Code ,
                    Amount = @Value ,
                    CurrencyCode = @Currency ,
                    TPCLogId = @TPCLogId
            WHERE   ProgramCode = @ProgramCode
                    AND ProductCode = @ProgramCode
                    AND RequestId = @RequestId

            
            UPDATE  dbo.CadoozVoucher
            SET     VoucherId = @VoucherId
            WHERE   Id = @CadoozVoucherId

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;

            SELECT  ERROR_MESSAGE()
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;

        SELECT  '0000'
    END

