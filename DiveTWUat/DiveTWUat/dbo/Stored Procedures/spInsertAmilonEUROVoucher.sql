
CREATE PROCEDURE [dbo].[spInsertAmilonEUROVoucher]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityStartDate DATETIME ,
    @ValidityEndDate DATETIME ,
    @ProductCode VARCHAR(50) ,
    @VendorProductCode VARCHAR(50) ,
    @CardCode VARCHAR(50) ,
    @RetailerCode VARCHAR(50) ,
    @RetailerName NVARCHAR(200) ,
    @Name NVARCHAR(200) ,
    @Surname NVARCHAR(200) ,
    @Email VARCHAR(50) ,
    @Dedication NVARCHAR(200) ,
    @OrderFrom NVARCHAR(200) ,
    @OrderTo NVARCHAR(200) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DECLARE @AmilonVoucherId BIGINT

        INSERT  INTO dbo.AmilonVoucher
                ( ProgramCode ,
                  VendorCode ,
                  VoucherId ,
                  VoucherLink ,
                  ValidityStartDate ,
                  ValidityEndDate ,
                  ProductCode ,
                  CardCode ,
                  RetailerCode ,
                  RetailerName ,
                  Name ,
                  Surname ,
                  Email ,
                  Dedication ,
                  OrderFrom ,
                  OrderTo ,
                  Amount ,
                  TPCLogId
		        )
        VALUES  ( @ProgramCode ,
                  @VendorCode ,
                  NULL ,
                  @VoucherLink ,
                  @ValidityStartDate ,
                  @ValidityEndDate ,
                  @VendorProductCode ,
                  @CardCode ,
                  @RetailerCode ,
                  @RetailerName ,
                  @Name ,
                  @Surname ,
                  @Email ,
                  @Dedication ,
                  @OrderFrom ,
                  @OrderTo ,
                  @Amount ,
                  @TPCLogId
		        )
        SELECT  @AmilonVoucherId = SCOPE_IDENTITY()

        BEGIN TRAN

        BEGIN TRY

            INSERT  dbo.Voucher
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
                      TPCLogId
                    )
            VALUES  ( @ProgramCode ,
                      @VendorCode ,
                      @CardCode ,
                      CONVERT(CHAR(10), @ValidityEndDate, 23) ,
                      @Amount ,
                      N'Euro' ,
                      @ProductCode ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId
                    )

            UPDATE  dbo.AmilonVoucher
            SET     VoucherId = SCOPE_IDENTITY()
            WHERE   Id = @AmilonVoucherId
           

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

