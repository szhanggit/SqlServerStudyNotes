
CREATE PROCEDURE [dbo].[spInsertBlackhawkVoucher]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @ProductCode NVARCHAR(50) ,
    @TransactionId NVARCHAR(500) ,
    @IsCompleted BIT ,
    @PercentComplete INT ,
    @Success BIT ,
    @OrderNumber NVARCHAR(500) ,
    @ContentProviderCode NVARCHAR(500) ,
    @TransactionAmount NUMERIC(20, 6) ,
    @CardNumber NVARCHAR(500) ,
    @Pin NVARCHAR(500) ,
    @Url NVARCHAR(500) ,
    @BarCodeValue NVARCHAR(500) ,
    @ExpirationDate NVARCHAR(500) ,
    @CreatedOn DATETIME
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @BlackhawkVoucherId BIGINT

        INSERT  INTO dbo.BlackhawkVoucher
                ( ProgramCode ,
                  VendorCode ,
                  VoucherId ,
                  TransactionId ,
                  IsCompleted ,
                  PercentComplete ,
                  Success ,
                  OrderNumber ,
                  ContentProviderCode ,
                  TransactionAmount ,
                  CardNumber ,
                  Pin ,
                  Url ,
                  BarCodeValue ,
                  ExpirationDate ,
                  TPCLogId	
                )
        VALUES  ( @ProgramCode ,
                  @VendorCode ,
                  NULL ,
                  @TransactionId ,
                  @IsCompleted ,
                  @PercentComplete ,
                  @Success ,
                  @OrderNumber ,
                  @ContentProviderCode ,
                  @TransactionAmount ,
                  @CardNumber ,
                  @Pin ,
                  @Url ,
                  @BarCodeValue ,
                  @ExpirationDate ,
                  @TPCLogId	
                )

        SELECT  @BlackhawkVoucherId = SCOPE_IDENTITY()

        BEGIN TRAN

        BEGIN TRY
            INSERT  INTO dbo.Voucher
                    ( ProgramCode ,
                      VendorCode ,
                      VoucherNumber ,
                      ExpiryDate ,
                      Amount ,
                      CurrencyCode ,
                      ProductCode ,
                      Status ,
                      CreatedOn ,
                      RequestId ,
                      TPCLogId ,
                      Password
		            )
            VALUES  ( @ProgramCode ,
                      @VendorCode ,
                      @CardNumber ,
                      @ExpirationDate ,
                      @TransactionAmount ,
                      N'' ,
                      @ProductCode ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId ,
                      @Pin
		            )


            UPDATE  dbo.BlackhawkVoucher
            SET     VoucherId = SCOPE_IDENTITY()
            WHERE   Id = @BlackhawkVoucherId


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

