
create   PROCEDURE [dbo].[spInsertRequestRelatedToVouchersRecord]
    @VoucherGUID uniqueidentifier,
    @RequestId VARCHAR(50) ,
	@vendor_code varchar(50) = null,
    @RequestRelatedToVouchersRecordId BIGINT OUTPUT
AS
    BEGIN
	 -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        INSERT  INTO dbo.RequestRelatedToVouchersRecord
                ( VoucherGUID ,
                  RequestId ,
                  CreatedTime,
				  VendorCode
		        )
        VALUES  ( @VoucherGUID ,
                  @RequestId ,
                  GETDATE(),
				  @vendor_code
		        )
	
        SELECT  @RequestRelatedToVouchersRecordId = SCOPE_IDENTITY()
    END;
