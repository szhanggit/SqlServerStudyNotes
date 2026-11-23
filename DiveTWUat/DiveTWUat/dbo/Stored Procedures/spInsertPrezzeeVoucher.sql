/*      
Procedure Name   : spInsertPrezzeeVoucher
Description      :  To Inserting Prezzee Merchant Data into Voucher,PrezzeeVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 14 Feb 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/
CREATE PROCEDURE [dbo].[spInsertPrezzeeVoucher]
    @ProgramCode VARCHAR(20) ,
    @VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityEndDate DATETIME ,
    @ProductCode VARCHAR(50) ,
    @CardCode VARCHAR(50) ,
    @RetailerCode VARCHAR(50) ,
    @RetailerName NVARCHAR(200)=null ,
    @Email VARCHAR(50)=null ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME ,
    @CurrencyCode VARCHAR(10) ,
    @EmailDeliveryStatus VARCHAR(500)=null ,
    @VocherUrlStatus VARCHAR(500) ,
    @ProductThemeCode NVARCHAR(500)=null ,
    @StyleCode NVARCHAR(500)=null
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
                      TPCLogId ,
                      VendorCode ,
                      ProductCode ,
                      Amount ,
                      CurrencyCode
                    )
            VALUES  ( @ProgramCode ,
                      @VoucherLink ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount ,
                      @CurrencyCode
                    )


            INSERT  INTO dbo.PrezzeeVoucher
                    ( ProgramCode ,
                      VoucherId ,
                      VoucherLink ,
                      ValidityEndDate ,
                      ProductCode ,
                      CardCode ,
                      RetailerCode ,
                      RetailerName ,
                      Email ,
                      Amount ,
                      EmailDeliveryStatus ,
                      VocherUrlStatus ,
                      CurrencyCode ,
                      ProductThemeCode ,
                      StyleCode ,
                      TPCLogId ,
                      VendorCode
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @VoucherLink ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @CardCode ,
                      @RetailerCode ,
                      @RetailerName ,
                      @Email ,
                      @Amount ,
                      @EmailDeliveryStatus ,
                      @VocherUrlStatus ,
                      @CurrencyCode ,
                      @ProductThemeCode ,
                      @StyleCode ,
                      @TPCLogId ,
                      @VendorCode
					  
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            SELECT  ERROR_MESSAGE();
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
        SELECT  '0000';
    END
