



/*      
Procedure Name   : spInsertTangoVoucher
Description      :  To Inserting Tango Merchant Data into Voucher,TangoVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 27 Feb 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/
---- exec '00001','U935268',

CREATE PROCEDURE [dbo].[spInsertTangoVoucher]
    @ProgramCode VARCHAR(20) ,
	@ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
	@VendorCode varchar(100),
	@CreatedOn DATETIME,
    @ReferenceOrderID VARCHAR(100) ,
    @CustomerIdentifier VARCHAR(100) ,
	@AccountIdentifier VARCHAR(100) ,
    @AccountNumber VARCHAR(100) ,
	@Amount NUMERIC(20, 6) ,
    @CurrencyCode VARCHAR(100) ,
    @Utid VARCHAR(100) ,
    @RewardName VARCHAR(100) ,
    @SendEmail bit,
    @Etid VARCHAR(100) ,
	@Status VARCHAR(100) ,
	@CreatedAt VARCHAR(100) ,
	@PIN VARCHAR(100) ,
	@SerialNumber VARCHAR(100) ,
	@RedemptionInstructions VARCHAR(max),
	@ClaimCode varchar(200), 
	@VoucherLink nvarchar(1000),
	@ExpiryDate varchar(200)
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
					  CurrencyCode
                    )
            VALUES  ( @ProgramCode ,
                     @ClaimCode ,
                     @ExpiryDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @VendorCode,
					  @ProductCode,
					  @Amount,
					  @CurrencyCode
                    )


            INSERT  INTO dbo.TangoVoucher
                    ( ProgramCode,
					  VoucherId ,
                      ProductCode ,
                      Amount ,
                      VendorCode ,
                      TpcLogId ,
                      ReferenceOrderID ,
                      CustomerIdentifier ,
                      AccountIdentifier ,
                      AccountNumber ,
                      CurrencyCode ,
                      Utid ,
                      RewardName ,
                      SendEmail ,
                      Etid ,
                      Status ,
                      CreatedAt ,
                      PIN ,
                      SerialNumber ,
                      RedemptionInstructions,
					  VoucherLink,
					  ClaimCode
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @ProductCode ,
                      @Amount ,
                      @VendorCode,
					  @TpcLogId,
					  @ReferenceOrderID ,
                      @CustomerIdentifier ,
                      @AccountIdentifier ,
                      @AccountNumber ,
                      @CurrencyCode ,
                      @Utid ,
                      @RewardName ,
                      @SendEmail ,
                      @Etid ,
                      @Status ,
                      @CreatedAt ,
                      @PIN ,
                      @SerialNumber ,
                      @RedemptionInstructions,
					  @VoucherLink,
					  @ClaimCode
                     
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				SELECT ERROR_MESSAGE()
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			SELECT '0000'
    END





