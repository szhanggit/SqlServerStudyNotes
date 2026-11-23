
/*      
Procedure Name   : spInsertBonagoVoucher
Description      :  To Inserting Bonago Merchant Data into Voucher,BonagoVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 20 Mer 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/


CREATE PROCEDURE [dbo].[spInsertBonagoVoucher]
    @ProgramCode VARCHAR(20) ,
	@RequestId VARCHAR(50) ,
	@ProductCode VARCHAR(50) ,
    @TPCLogId BIGINT ,
	@VendorCode varchar(50),
	@CreatedOn DATETIME,
	@Status varchar(100),
	@RetailerName varchar(500),
	@CountryCode varchar(10),
	@Denomination NUMERIC(20, 6) ,
    @Code VARCHAR(500) ,
    @OrderItemClaimId NVARCHAR(200) ,
	@CodesCount varchar(10)
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
					  Misc1
                    )
            VALUES  ( @ProgramCode ,
                      @Code  ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @VendorCode,
					  @ProductCode,
					  @Denomination ,
					  @CountryCode
                    )


            INSERT  INTO dbo.BonagoVoucher
                    ( ProgramCode ,
					  VoucherId ,
                      VendorCode ,
                      ProductCode ,
                      Code ,
                      Amount ,
                      CountryCode ,
                      TpcLogId ,
                      Status ,
                      RetailerName ,
                      OrderItemClaimId ,
                      CodesCount 
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
					  @VendorCode, 
                      @ProductCode ,
					  @Code ,
                      @Denomination,
					  @CountryCode,
                      @TpcLogId,
					  @Status,
					  @RetailerName ,
                      @OrderItemClaimId ,
                      @CodesCount 
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






