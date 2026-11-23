/*      
Procedure Name   : spInsertGlobalGivingVoucher
Description      :  To Inserting GlobalGiving Merchant Data into Voucher,GlobalGivingVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 11 Oct 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/
create PROCEDURE [dbo].[spInsertGlobalGivingVoucher]
    @programCode VARCHAR(20) ,
	@productCode VARCHAR(50) ,
	@vendorCode VARCHAR(50) ,
	@tpcLogId BIGINT ,
    @requestId VARCHAR(50) ,
    @amount NUMERIC(20, 6) ,
	@currencyCode varchar(10)=null,
	@expirationDate  VARCHAR(100)=null,
	@giftCertificateNumber  VARCHAR(500),
	@remainingAmount  VARCHAR(10)=null,
    @url VARCHAR(500),
	@accessToken nvarchar(500)
   
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
					  CurrencyCode,
					  ExpiryDate
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
					  @currencyCode,
					  @expirationDate
                    )


            INSERT  INTO dbo.GlobalGivingVoucher
                    ( ProgramCode
					  ,VoucherId
                      ,VoucherLink
                      ,ProductCode
                      ,Amount
                      ,TPCSupplierCode
                      ,CurrencyCode
                      ,TpcLogId
					  ,GiftCertificateNumber
					  ,RemainingAmount
					  ,ExpirationDate
					  ,AccessToken
                      
		            )
            VALUES  ( @programCode ,
                      SCOPE_IDENTITY() ,
                      @url ,
                      @productCode ,
                      @amount ,
                      @vendorCode,
					  @currencyCode, 
                      @tpcLogId,
					  @giftCertificateNumber
					  ,@remainingAmount
					  ,@expirationDate
					  ,@accessToken
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





