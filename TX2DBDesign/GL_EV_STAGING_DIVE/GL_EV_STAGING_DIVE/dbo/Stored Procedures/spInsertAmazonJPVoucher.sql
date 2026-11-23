


/*      
Procedure Name   : spInsertAmazonJPVoucher
Description      :  To Inserting AmazonJP Merchant Data into Voucher,AmazonVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 21 Feb 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/


create PROCEDURE [dbo].[spInsertAmazonJPVoucher]
    @ProgramCode VARCHAR(20) ,
	@ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @GcClaimCode VARCHAR(500) ,
    @ValidityEndDate NVARCHAR(200) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME,
	@VendorCode varchar(50),
	@CurrencyCode varchar(10),	
	@GcId varchar(100),
	@Status varchar(100),
	@CreateOrderRequestId varchar(100)
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
					  CurrencyCode,
					  Misc1
                    )
            VALUES  ( @ProgramCode ,
                      @GcClaimCode  ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @VendorCode,
					  @ProductCode,
					  @Amount,
					  @CurrencyCode,
					  @GcId
                    )


            INSERT  INTO dbo.AmazonVoucher
                    ( ProgramCode ,
                      VoucherId,
                      GcClaimCode ,             
                      ValidityEndDate ,
                      ProductCode ,
                      Amount,
					  VendorCode,
					  CurrencyCode,
                      TpcLogId,
					  GcId,
					  Status,
					 CreateOrderRequestId
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @GcClaimCode ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @Amount ,
                      @VendorCode, 
					  @CurrencyCode,
                      @TpcLogId,
					  @GcId,
					  @Status,
					  @CreateOrderRequestId
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				SELECT ERROR_MESSAGE();
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			SELECT '0000';
    END





