
/*      
Procedure Name   : spInsertGoGiftSEVoucher
Description      :  To Inserting GoGift Merchant Data into Voucher,GoGiftVoucher 
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


CREATE PROCEDURE [dbo].[spInsertGoGiftSEVoucher]
    @ProgramCode VARCHAR(20) ,
	@ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityEndDate NVARCHAR(200) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME,
	@TPCSupplierCode varchar(500),
	@CurrencyCode varchar(10),
	@SessionId NVARCHAR(1000),
    @OrderId VARCHAR(500),
    @OrderToken  VARCHAR(500),
	@CodeStatus varchar(10),
	@Balance NUMERIC(20, 6) ,
	@IsComplete bit
	
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  dbo.Voucher
                    ( ProgramCode ,
                      --VoucherNumber ,
                      ExpiryDate ,
                      Status ,
                      CreatedOn ,
                      RequestId ,
                      TPCLogId,
					  SupplierCode,
					  ProductCode,
					  Amount,
					  CurrencyCode
                    )
            VALUES  ( @ProgramCode ,
                     -- @CardCode ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @TPCSupplierCode,
					  @ProductCode,
					  @Amount,
					  @CurrencyCode
                    )


            INSERT  INTO dbo.GoGiftVoucher
                    ( ProgramCode ,
                      VoucherId,
                      VoucherLink ,             
                      ValidityEndDate ,
                      ProductCode ,
                      Amount,
					  TPCSupplierCode,
					  CodeStatus,
					  Balance,
					  CurrencyCode,
					  IsComplete,
					  SessionId,
                      OrderId,
                      OrderToken,
                      TpcLogId
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @VoucherLink ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @Amount ,
                      @TPCSupplierCode,
					  @CodeStatus,
					  @Balance,
					  @CurrencyCode,
					  @IsComplete,
					  @SessionId,
                      @OrderId,
                      @OrderToken,
                      @TpcLogId
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				SELECT ERROR_MESSAGE();
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			select '0000'
    END


