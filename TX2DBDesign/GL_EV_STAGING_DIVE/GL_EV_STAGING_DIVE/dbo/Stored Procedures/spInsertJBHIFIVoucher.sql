
/*      
Procedure Name   : spInsertJBHIFIVoucher
Description      :  To Inserting JBHIFI Merchant Data into Voucher,JBHIFIVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 14 Feb 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/
-- exec spInsertJBHIFIVoucher '0001','009e12bc-ea0e-4cb4-8a5f-8078ccc0a12d',227,'https://stage.viicloud.com.au/digital/dd.aspx?c=502904030361612806&h=0xbcaa315cd1cb4ad0d9922e203c239b0197655c5f',
-- '2/14/2020 12:00:00 AM','2/14/2018 12:00:00 AM','JBAUAPIEdR','502904030361612806',50.6,'2/14/2019','JBHIFI','3616128','5826',
-- 'JBAU235074',50.6,50.6,'gary.tsang@edenred.com','009e12bc-ea0e-4cb4-8a5f-8078ccc0a12d','Ok',1

Create PROCEDURE [dbo].[spInsertJBHIFIVoucher]
    @ProgramCode VARCHAR(20) ,
	@VendorCode VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @TPCLogId BIGINT ,
    @VoucherLink VARCHAR(500) ,
    @ValidityStartDate NVARCHAR(200) ,
    @ValidityEndDate NVARCHAR(200) ,
    @ProductCode VARCHAR(50) ,
    @CardCode VARCHAR(50) ,
    @Amount NUMERIC(20, 6) ,
    @CreatedOn DATETIME,
	@SerialNumber NVARCHAR(200),
	@PIN VARCHAR(200),
	@OrderNumber NVARCHAR(200),
	@AvailableBalance NUMERIC(20, 6) ,
	@CurrentBalance NUMERIC(20, 6),
	@UserName NVARCHAR(200),
	@TranId  NVARCHAR(200),
	@ResponseMessage NVARCHAR(200),
	@CardStatusId int
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRAN

        BEGIN TRY

            INSERT  dbo.Voucher
                    ( ProgramCode ,
					  VendorCode,
                      VoucherNumber ,
                      ExpiryDate ,
                      Status ,
                      CreatedOn ,
                      RequestId ,
                      TPCLogId,
					  ProductCode,
					  Amount
                    )
            VALUES  ( @ProgramCode ,
					  @VendorCode,
                      @CardCode ,
                      @ValidityEndDate ,
                      1 ,
                      @CreatedOn ,
                      @RequestId ,
                      @TPCLogId,
					  @ProductCode,
					  @Amount
                    )


            INSERT  INTO dbo.JBHIFIVoucher
                    ( ProgramCode ,
                      VoucherId ,
                      VoucherLink ,
                      ValidityStartDate ,
                      ValidityEndDate ,
                      ProductCode ,
                      CardCode ,
                      Amount,
					  AvailableBalance,
					  CurrentBalance,
					  ResponseMessage,
					  SerialNumber,
					  PIN,
					  OrderNumber,
					  UserName,
					  TranId,
					  CardStatusId,
					  TPCLogId,
					  VendorCode
		            )
            VALUES  ( @ProgramCode ,
                      SCOPE_IDENTITY() ,
                      @VoucherLink ,
                      @ValidityStartDate ,
                      @ValidityEndDate ,
                      @ProductCode ,
                      @CardCode ,
                      @Amount,
					  @AvailableBalance,
					  @CurrentBalance,
					  @ResponseMessage,
					  @SerialNumber,
					  @PIN,
					  @OrderNumber,
					  @UserName,
					  @TranId,
					  @CardStatusId,
					  @TPCLogId,
					  @VendorCode
		            )

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
				--INSERT into errorLogTable(Messagee)
				 select ERROR_MESSAGE();
        END CATCH;

        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
			SELECT '0000';
    END

