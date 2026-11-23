/*      
Procedure Name   : spInsertAmazonCNVoucher
Description      :  To Inserting AmazonCN Merchant Data into Voucher,AmazonVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 13 Mer 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/


CREATE PROCEDURE [dbo].[spInsertAmazonCNVoucher]
    @ProgramCode VARCHAR(20) ,
    @ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @GcClaimCode VARCHAR(500) ,
    @ValidityEndDate NVARCHAR(200) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME ,
    @VendorCode VARCHAR(50) ,
    @CurrencyCode VARCHAR(10) ,
    @GcId VARCHAR(100) ,
    @Status VARCHAR(100) ,
    @CreateOrderRequestId VARCHAR(100)
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
                      CurrencyCode ,
                      Misc1
                    )
            VALUES  ( @ProgramCode ,
                      @GcClaimCode ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount ,
                      @CurrencyCode ,
                      @GcId
                    )


            INSERT  INTO dbo.AmazonVoucher
                    ( ProgramCode ,
                      VendorCode ,
                      VoucherId ,
                      GcClaimCode ,
                      ValidityEndDate ,
                      ProductCode ,
                      Amount ,
                      CurrencyCode ,
                      TpcLogId ,
                      GcId ,
                      Status ,
                      CreateOrderRequestId
		            )
            VALUES  ( @ProgramCode ,
                      @VendorCode ,
                      SCOPE_IDENTITY() ,
                      @GcClaimCode ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @Amount ,
                      @CurrencyCode ,
                      @TpcLogId ,
                      @GcId ,
                      @Status ,
                      @CreateOrderRequestId
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


