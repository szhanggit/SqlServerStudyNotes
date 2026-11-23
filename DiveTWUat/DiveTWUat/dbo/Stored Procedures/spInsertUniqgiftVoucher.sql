
CREATE PROCEDURE [dbo].[spInsertUniqgiftVoucher]
    @ProgramCode VARCHAR(20) ,
	@RequestId VARCHAR(50) ,
	@TPCLogId BIGINT ,
	@ProductCode VARCHAR(50) ,
    @VendorCode varchar(100),
    @CreatedOn DATETIME,
	@S_OrderNumber VARCHAR(50) ,
	@S_VoucherGuid uniqueidentifier ,
	@S_ProgramCode VARCHAR(20) ,
	@S_VoucherNo VARCHAR(50) ,
	@S_ShortUrl VARCHAR(500) ,
	@S_ShortUrlAuthCode nvarchar(100) ,
	@S_ExpirationDate DATETIME
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  dbo.Voucher
                    ( ProgramCode ,
                      VoucherNumber ,
                      ExpiryDate ,
                      Status ,
                      CreatedOn ,
                      RequestId ,
                      TPCLogId,
					  VendorCode,
					  ProductCode ,
					  Password
                    )
            VALUES  ( @ProgramCode ,
                      @S_ShortUrl ,
                      @S_ExpirationDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @VendorCode,
					  @ProductCode,
					  @S_ShortUrlAuthCode
                    )


            INSERT  INTO dbo.UniqgiftVoucher
                    ( ProgramCode,
					  VoucherId ,
                      ProductCode ,
                      VendorCode ,
                      TpcLogId ,
					  [S_OrderNumber] ,
                      [S_VoucherGuid] ,
                      [S_ProgramCode],
					  [S_VoucherNo],
					  [S_ExpirationDate],
					  [S_ShortUrl],
					  [S_ShortUrlAuthCode]
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @ProductCode ,
                      @VendorCode,
					  @TpcLogId,
					  @S_OrderNumber ,
                      @S_VoucherGuid ,
                      @S_ProgramCode ,
					  @S_VoucherNo,
                      @S_ExpirationDate ,
                      @S_ShortUrl,
					  @S_ShortUrlAuthCode				  
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				SELECT ERROR_MESSAGE()
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			SELECT '0000'
    END


