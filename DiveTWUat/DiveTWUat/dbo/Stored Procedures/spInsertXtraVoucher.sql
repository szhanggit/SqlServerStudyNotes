

/*      
Procedure Name   : spInsertXtraVoucher
Description      :  To Inserting Xtra Merchant Data into Voucher,XtraVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 02 Dec 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/


CREATE PROCEDURE [dbo].[spInsertXtraVoucher]
    @ProgramCode VARCHAR(20) ,
    @ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
	@VendorCode varchar(100),
	@Status varchar(100)= null,
	@VoucherID VARCHAR(50) ,
    @VoucherLink varchar(500)
    
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
                      ProductCode 
                    )
            VALUES  ( @ProgramCode ,
                      @VoucherLink,
                      1 ,
                      getdate() ,
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode 
                    )


            INSERT  INTO dbo.XtraVoucher
                    ( ProgramCode
                      ,TpcLogId
                      ,VoucherId
                      ,VoucherLink
                      ,CuponID
                      ,ProductCode
                      ,TPCSupplierCode
		            )
            VALUES  ( @ProgramCode ,
			          @TpcLogId ,
					  SCOPE_IDENTITY() ,
                      @VoucherLink,
                      @VoucherID,
                      @ProductCode ,
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


