/*      
Procedure Name   : spInsertMommentsVoucher
Description      :  To Inserting Momments Merchant Data into Voucher,MommentsVoucher 
Notes            :       
Author           : Sagam     
Created Date     : 25 July 2019
Modification Log :       
-----------------------------------------------------------------------------------      
Modified By       Date             Change Description      Reference#(If Any)  
-----------------------------------------------------------------------------------      
<Name>                             <desc>  
-----------------------------------------------------------------------------------  
*/

create proc [dbo].[spInsertMommentsVoucher]
(
@ProgramCode varchar(200)= null,
@ProductCode   varchar(200)=null,
@RequestId varchar(200)=null,
@TPCLogId	varchar(200)=null,
@VendorCode	 varchar(200)=null,
@ID bigint=null,  
@OrderNumber  varchar(200)=null,
@StatusOfOrder varchar(200)=null,
@TypeofOrder varchar(200)=null,
@Client	varchar(200)=null,
@GiftCard varchar(2000)=null,
@ValidFrom	varchar(200)=null,
@ValidTo varchar(200)=null,
@Amount	numeric(20,6)=null,
@Url	nvarchar(2000)=null,
@Token	nvarchar(1000)=null
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
                      Amount,
					  ExpiryDate 
                    )
            VALUES  ( @ProgramCode ,
                      @Url,
                      1 ,
                      GETDATE(),
                      @RequestId ,
                      @TPCLogId ,
                      @VendorCode ,
                      @ProductCode ,
                      @Amount ,
					  @ValidTo
                    )


            INSERT  INTO dbo.MommentsVoucher
                    ( ProgramCode
                      ,ProductCode
                      ,VendorCode
                      ,VoucherId
                      ,Amount
                      ,TPCLogId
                      ,Status
                      ,MommentsID
                      ,OrderNumber
                      ,StatusOfOrder
                      ,TypeofOrder
                      ,Client
                      ,GiftCard
                      ,ValidFrom
                      ,ValidTo
                      ,Url
                      ,Token
		            )
            VALUES  ( @ProgramCode
                      ,@ProductCode
                      ,@VendorCode
                      ,SCOPE_IDENTITY() 
                      ,@Amount
                      ,@TPCLogId
                      ,1
                      ,@ID
                      ,@OrderNumber
                      ,@StatusOfOrder
                      ,@TypeofOrder
                      ,@Client
                      ,@GiftCard
                      ,@ValidFrom
                      ,@ValidTo
                      ,@Url
                      ,@Token
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






