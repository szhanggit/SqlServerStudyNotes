
/*      
Procedure Name   : spInsertTopUpPhoneVoucher
Description      :  To Inserting TopUpPhone Merchant Data into Voucher,TopUpPhoneVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 27 May 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/

create proc [dbo].[spInsertTopUpPhoneVoucher]
(
@ProgramCode varchar(50),
@ProductCode varchar(50),
@VendorCode varchar(50),
@TpcLogId varchar(50),
@RequestId varchar(50),
@Amount NUMERIC(20, 6) ,
@TransactionID varchar(50),
@AccessMessage varchar(500),
@Pin varchar(50),
@SerialNumber varchar(500),
@Cost NUMERIC(20, 6)=null ,
@CommPerc NUMERIC(20, 6)=null, 
@CommDollar NUMERIC(20, 6)=null,
@TransactionDate varchar(100)=null,
@AccessCode varchar(100)=null
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
                      @SerialNumber,
                      1 ,
                      GETDATE(),
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount 
                    )


            INSERT  INTO dbo.TopUpPhoneVoucher
                    ( ProgramCode
                      ,VendorCode
                      ,VoucherId
                      ,ProductCode
                      ,Amount
                      ,TPCLogId
                      ,Status
                      ,Pin
                      ,SerialNumber
                      ,RequsetID
                      ,CommPerc
                      ,CommDollar
                      ,Cost
                      ,TransactionID
		            )
            VALUES  (@ProgramCode ,
                     @VendorCode   ,
                     SCOPE_IDENTITY() ,
                     @ProductCode	 ,
                     @Amount		 ,
                     @TPCLogId	 ,
                     @AccessMessage	 ,
                     @Pin            ,
                     @SerialNumber	 ,
                     @RequestId ,
                     @CommPerc		 ,
                     @CommDollar	 ,
                     @Cost			 ,
                     @TransactionID	 
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


