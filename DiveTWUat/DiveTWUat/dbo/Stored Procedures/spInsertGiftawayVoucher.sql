

/*      
Procedure Name   : spInsertGiftawayVoucher
Description      :  To Inserting Giftaway Merchant Data into Voucher,GiftawayVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 09 May 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/

create proc spInsertGiftawayVoucher
(
@ProgramCode varchar(50),
@ProductCode varchar(50),
@VendorCode varchar(50),
@TpcLogId varchar(50),
@RequestId varchar(50),
@Amount NUMERIC(20, 6) ,
@StatusCode varchar(50),
@Status varchar(50),
@OrderID varchar(50),
@Urls varchar(50),
@CreditsUsed NUMERIC(20, 6) ,
@CreditBalance NUMERIC(20, 6) 
)
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
                      TPCLogId ,
                      VendorCode ,
                      ProductCode ,
                      Amount 
                    )
            VALUES  ( @ProgramCode ,
                      @Urls,
                      1 ,
                      GETDATE(),
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount 
                    )


            INSERT  INTO dbo.GiftawayVoucher
                    ( ProgramCode ,
                      VendorCode   ,
                      VoucherId	 ,
                      VoucherLink	 ,
                      ProductCode	 ,
                      Amount		 ,
                      TPCLogId	 ,
                      StatusCode	 ,
                      Status		 ,
                      OrderID		 ,
                      ReferenceNO	 ,
                      CreditsUsed	 ,
                      CreditBalance
		            )
            VALUES  (@ProgramCode ,
                     @VendorCode   ,
                     SCOPE_IDENTITY() ,
                     @Urls	 ,
                     @ProductCode	 ,
                     @Amount		 ,
                     @TPCLogId	 ,
                     @StatusCode	 ,
                     @Status		 ,
                     @OrderID		 ,
                     @RequestId	 ,
                     @CreditsUsed	 ,
                     @CreditBalance
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


