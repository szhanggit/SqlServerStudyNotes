
/*      
Procedure Name   : spInsertCashwaveVoucher
Description      :  To Inserting Cashwave Merchant Data into Voucher,CashwaveVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 25 June 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/

create proc [dbo].[spInsertCashwaveVoucher]
(
@ProgramCode varchar(50),
@ProductCode varchar(50),
@VendorCode varchar(50),
@TpcLogId varchar(50),
@RequestId varchar(50),
@OrderLineRef varchar(500),
@Amount NUMERIC(20, 6) ,
@Code varchar(500),
@NominalValue NUMERIC(20, 6) ,
@Currency varchar(10),
@ExpiresAt varchar(50),
@ID varchar(100)
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
					  ExpiryDate,
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
                      @Code,
					  @ExpiresAt,
                      1 ,
                      GETDATE(),
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount ,
					  @Currency
                    )


            INSERT  INTO dbo.CashwaveVoucher
                    ( ProgramCode
                      ,VendorCode
                      ,VoucherId
                      ,ProductCode
                      ,TPCLogId
                      ,OrderLineRef
                      ,Code
                      ,Amount
                      ,Currency
                      ,RequsetID
                      ,NominalValue
                      ,ExpiresAt
		            )
            VALUES  (@ProgramCode ,
                     @VendorCode   ,
                     SCOPE_IDENTITY() ,
                     @ProductCode	 ,
					 @TPCLogId	 ,
                     @OrderLineRef
                      ,@Code
                      ,@Amount
                      ,@Currency
                      ,@RequestId
                      ,@NominalValue
                      ,@ExpiresAt
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



