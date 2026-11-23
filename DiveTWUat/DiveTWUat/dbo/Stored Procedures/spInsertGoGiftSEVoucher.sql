

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


create PROCEDURE [dbo].[spInsertGoGiftSEVoucher]
    @ProgramCode VARCHAR(20) ,
	@VendorCode VARCHAR(50) ,
	@ProductCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityEndDate NVARCHAR(200) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME,
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
		DECLARE @VoucherId BIGINT
        DECLARE @GoGiftDKVoucherId BIGINT
		
		INSERT  INTO dbo.GoGiftVoucher
                    ( ProgramCode ,
                      VendorCode ,
                      VoucherId ,
                      VoucherLink ,
                      ValidityEndDate ,
                      ProductCode ,
                      Amount ,
                      CodeStatus ,
                      Balance ,
                      CurrencyCode ,
                      IsComplete ,
                      SessionId ,
                      OrderId ,
                      OrderToken ,
                      TpcLogId
		            )
            VALUES  ( @ProgramCode ,
                      @VendorCode ,
                      NULL,
                      @VoucherLink ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @Amount ,
                      @CodeStatus ,
                      @Balance ,
                      @CurrencyCode ,
                      @IsComplete ,
                      @SessionId ,
                      @OrderId ,
                      @OrderToken ,
                      @TpcLogId
		            )
					
		SELECT  @GoGiftDKVoucherId = SCOPE_IDENTITY()

        BEGIN TRAN

        BEGIN TRY

            UPDATE  dbo.Voucher
            SET     @VoucherId = Id ,
                    VoucherNumber = @VoucherLink ,
					ExpiryDate = @ValidityEndDate,
					CreatedOn = @CreatedOn,
                    Amount = @Amount ,
                    CurrencyCode = @CurrencyCode ,
                    TPCLogId = @TPCLogId
            WHERE   ProgramCode = @ProgramCode
                    AND RequestId = @RequestId


            UPDATE  dbo.GoGiftVoucher
            SET     VoucherId = @VoucherId
            WHERE   Id = @GoGiftDKVoucherId

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



