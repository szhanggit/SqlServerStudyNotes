
CREATE PROCEDURE spInsertVoucherSupplierAPILog_TPC
    @LocalId BIGINT ,
    @OperationName VARCHAR(50) ,
    @RequestId VARCHAR(50) ,
    @RequestMessage NVARCHAR(MAX) = NULL ,
    @OriginalRequestId VARCHAR(50) = NULL ,
    @ProductCode VARCHAR(50) = NULL ,
    @ExternalProductCode VARCHAR(50) = NULL ,
    @SupplierCode NVARCHAR(50) = NULL ,
    @TPCLogId BIGINT OUTPUT
AS
    BEGIN
	 -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        INSERT  INTO dbo.VoucherSupplierAPILog_TPC
                ( LocalId ,
                  OperationName ,
                  RequestId ,
                  CreatedOn ,
                  RequestMessage ,
                  OriginalRequestId ,
                  ProductCode ,
                  ExternalProductCode ,
                  SupplierCode
		        )
        VALUES  ( @LocalId ,
                  @OperationName ,
                  @RequestId ,
                  GETDATE() ,
                  @RequestMessage ,
                  @OriginalRequestId ,
                  @ProductCode ,
                  @ExternalProductCode ,
                  @SupplierCode
		        )
	
        SELECT  @TPCLogId = SCOPE_IDENTITY()
    END;
