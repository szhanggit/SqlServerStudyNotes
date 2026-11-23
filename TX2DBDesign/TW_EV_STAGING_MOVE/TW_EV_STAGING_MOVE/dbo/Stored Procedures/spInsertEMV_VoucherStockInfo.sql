
CREATE PROCEDURE [dbo].[spInsertEMV_VoucherStockInfo]
    @BatchId varchar(50),
	@Rows EMV_VoucherStockUploadRow Readonly
AS
BEGIN
	SET NOCOUNT ON;
    declare @now datetime = getdate()
    INSERT INTO [dbo].[EMV_VoucherStock]
           ([BatchId]
           ,[Denomination]
           ,[SKU]
           ,[VoucherCode]
           ,[IssueDate]
           ,[ExpiryDate]
           ,[GUID]
           ,[GCID]
           ,[PODate]
           ,[PONumber]
           ,[PIN]
           ,[CreatedTime])
     Select @BatchId
     ,Denomination
     ,SKU
     ,VoucherCode
     ,IssueDate
     ,ExpiryDate
     ,[GUID]
     ,GCID
     ,PODate
     ,PONumber
     ,PIN
     ,@now
     From @Rows

     SELECT * from @Rows
END
