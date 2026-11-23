/*      
Procedure Name   : spInsertYouGotaGIFTVoucher
Description      :  To Inserting YouGotAGift Merchant Data into Voucher,YouGotAGiftVoucher 
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

/*exec spInsertYouGotaGIFTVoucher '0001','20190131104222',64,'https://xxxxxx.com/gifts/barcode/generate/4827709516917/',
null,'9/20/2018 12:00:00 AM','184726','4827709516917',null,null,null,null,null,null,null,null,100,'9/20/2018 12:00:00 AM'
*/
Create PROCEDURE [dbo].[spInsertYouGotaGIFTVoucher]
    @ProgramCode VARCHAR(20) ,
	@VendorCode VARCHAR(50) ,
	@ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
	@CurrencyCode varchar(10),
	@Amount NUMERIC(20, 6) ,
    @VoucherLink VARCHAR(500) ,
    @ValidityEndDate DATETIME ,
    @CardCode VARCHAR(50) ,
	@CreatedOn VARCHAR(50),
	@OrderId VARCHAR(20) ,
	@State VARCHAR(10) ,
	@ReferenceId VARCHAR(30) ,
	@DeliveryType VARCHAR(10),
	@PdfLink varchar(1000)
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
					

            INSERT  INTO dbo.YouGotAGiftVoucher
                    ( ProgramCode ,
					  VendorCode,
                      VoucherId  ,
                      VoucherLink ,
                      ValidityEndDate ,
                      ProductCode ,
                      CardCode ,
                      Amount ,
                      TPCLogId ,
                      CurrencyCode ,
                      OrderId ,
                      State ,
                      ReferenceId ,
                      DeliveryType ,
					  PdfLink
		            )
            VALUES  ( @ProgramCode ,
			          @VendorCode,
                      SCOPE_IDENTITY() ,
                      @VoucherLink ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @CardCode ,
                      @Amount,
					  @TPCLogId ,
                      @CurrencyCode ,
                      @OrderId ,
                      @State ,
                      @ReferenceId ,
                      @DeliveryType ,
					  @PdfLink
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

