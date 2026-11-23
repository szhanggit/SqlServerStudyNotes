

CREATE PROCEDURE [dbo].[spInsert_BatchMemoRow]
  @BatchMemoId INT
 ,@GUID [varchar] (40)
 ,@Alias [varchar] (20)
 ,@VoucherNumber [varchar] (50)
 ,@Memo [nvarchar](2000) 
 ,@IsSuccess [bit]
 ,@StatusMessage [nvarchar](500)
 ,@CreatedTime DATETIME
 AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[BatchMemoRow] (
	[BatchMemoId]
	 ,[GUID]
	 ,[Alias]
	 ,[VoucherNumber]
	 ,[Memo]
	 ,[IsSuccess]
	 ,[StatusMessage]
	 ,[CreatedTime]
	)
	VALUES(
	@BatchMemoId
	 ,@GUID
	 ,@Alias
	 ,@VoucherNumber
	 ,@Memo
	 ,@IsSuccess
	 ,@StatusMessage
	 ,@CreatedTime
	)

SELECT SCOPE_IDENTITY()

END
