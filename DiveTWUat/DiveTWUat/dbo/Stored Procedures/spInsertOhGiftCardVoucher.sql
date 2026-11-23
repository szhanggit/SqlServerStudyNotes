


/*      
Procedure Name   : spInsertOhGiftCardVoucher
Description      :  To Inserting OhGift Merchant Data into Voucher,OhGiftVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 10 Sep 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/


create PROCEDURE [dbo].[spInsertOhGiftCardVoucher]
    @programCode VARCHAR(20) ,
	@productCode VARCHAR(50) ,
	@vendorCode VARCHAR(50) ,
	@tpcLogId BIGINT ,
    @requestId VARCHAR(50) ,
    @amount NUMERIC(20, 6) ,
	@currency varchar(10)=null,
	@transactionID  VARCHAR(500),
    @url VARCHAR(500) 
   
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
                      Status ,
                      CreatedOn ,
                      RequestId ,
                      TPCLogId,
					  VendorCode,
					  ProductCode,
					  Amount,
					  CurrencyCode
                    )
            VALUES  ( @programCode ,
                      @url , 
                      1 ,
                      GETDATE() ,
                      @requestId ,
                      @tpcLogId,
					  @vendorCode,
					  @productCode,
					  @amount,
					  @currency
                    )


            INSERT  INTO dbo.OhGiftCardVoucher
                    ( ProgramCode
					  ,VoucherId
                      ,VoucherLink
                      ,ProductCode
                      ,Amount
                      ,TPCSupplierCode
                      ,CurrencyCode
                      ,transactionID
                      ,TpcLogId
                      
		            )
            VALUES  ( @programCode ,
                      SCOPE_IDENTITY() ,
                      @url ,
                      @productCode ,
                      @amount ,
                      @vendorCode,
					  @currency,
					  @transactionID,
                      @tpcLogId
		            )

          END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				SELECT ERROR_MESSAGE();
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			select '0000';
    END





