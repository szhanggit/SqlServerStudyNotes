/*      
Procedure Name   : spInsertIncentivaleVoucher
Description      :  To Inserting Incentival Merchant Data into Voucher,IncentivalVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 21 Oct 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/
CREATE PROCEDURE [dbo].[spInsertIncentivaleVoucher]
    @ProgramCode VARCHAR(20) ,
	@RequestId VARCHAR(50) ,
	@TPCLogId BIGINT ,
	@ProductCode varchar(50) ,
    @Amount NUMERIC(20, 6) ,
	@MessageReturn nvarchar(1000)=null,
	@Availability  VARCHAR(10)=null,
	@CardCode  VARCHAR(500),
	@ValidityEndDate  VARCHAR(20)=null,
	@Access_Token nvarchar(max),
	@VendorCode VARCHAR(50)=null
   
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
					  ProductCode,
					  Amount,
					  ExpiryDate,
					  VendorCode
                    )
            VALUES  ( @ProgramCode ,
                      @CardCode , 
                      1 ,
                      GETDATE() ,
                      @RequestId ,
                      @TpcLogId,
					  @ProductCode,
					  @Amount,
					  @ValidityEndDate,
					  @VendorCode
                    )


            INSERT  INTO dbo.IncentivaleVoucher
                    ( ProgramCode
                      ,VoucherId
                      ,ProductCode
                      ,Amount
                      ,TPCLogId
                      ,RequsetID
                      ,CardCode
                      ,Availability
                      ,ValidityEndDate
                      ,MessageReturn
					  ,Access_Token
                      
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @ProductCode ,
                      @Amount ,
                      @TpcLogId
					  ,@RequestId
                      ,@CardCode
                      ,@Availability
                      ,@ValidityEndDate
                      ,@MessageReturn
					  ,@Access_Token
                      
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





