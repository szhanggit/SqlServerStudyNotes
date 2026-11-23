
/*      
Procedure Name   : spInsertWogiSGDVoucher
Description      :  To Inserting WOGI Merchant Data into Voucher,WOGIVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 31 Jan 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/

/*exec spInsertWogiSGDVoucher '0001','20190131104222',64,'https://xxxxxx.com/gifts/barcode/generate/4827709516917/',
null,'9/20/2018 12:00:00 AM','184726','4827709516917',null,null,null,null,null,null,null,null,100,'9/20/2018 12:00:00 AM'
*/
Create PROCEDURE [dbo].[spInsertWogiSGDVoucher]
    @ProgramCode VARCHAR(20) ,
	@VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityStartDate NVARCHAR(200) ,
    @ValidityEndDate NVARCHAR(200) ,
    @ProductCode VARCHAR(50) ,
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
    @CreatedOn DATETIME,
	@CurrencyCode varchar(10),
	@ActivationUrl NVARCHAR(1000),
    @ActivationNumber VARCHAR(500),
    @ActivationPin  VARCHAR(500)
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
					  ProductCode,
					  Amount,
					  CurrencyCode
                    )
            VALUES  ( @ProgramCode ,
                      @CardCode ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @VendorCode,
					  @ProductCode,
					  @Amount,
					  @CurrencyCode
                    )


            INSERT  INTO dbo.WOGIVoucher
                    ( ProgramCode ,
                      VoucherId ,
                      VoucherLink ,
                      ValidityStartDate ,
                      ValidityEndDate ,
                      ProductCode ,
                      CardCode ,
                      ActivationUrl ,
                      ActivationNumber ,
                      ActivationPin  ,
                      Surname ,
                      Email ,
                      Dedication ,
                      OrderFrom ,
                      OrderTo ,
                      Amount,
					  TPCLogId,
					  VendorCode
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @VoucherLink ,
                      @ValidityStartDate ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @CardCode ,
                      @ActivationUrl ,
                      @ActivationNumber ,
                      @ActivationPin  ,
					  @Surname ,
                      @Email ,
                      @Dedication ,
                      @OrderFrom ,
                      @OrderTo ,
                      @Amount,
					  @TPCLogId,
					  @VendorCode
		            )

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

