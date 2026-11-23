

CREATE PROCEDURE [dbo].[spInsert_BatchMemo]
 @FileName NVARCHAR (300)
 ,@FileSource NVARCHAR (20)
 ,@CreatedTime DATETIME
 ,@TotalRows INT
 ,@Status INT
 ,@BatchNo VARCHAR(50)
 ,@UpdatedBy VARCHAR(50)
 AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[BatchMemo] (
	[FileName]
	,[BatchNumber]
	,[CreatedTime]
	,[TotalRows]
	,[Status]
	,[UpdatedBy]
	)
	VALUES(
	@FileName
	,@BatchNo
	,@CreatedTime
	,@TotalRows
	,@Status
	,@UpdatedBy
	)

SELECT SCOPE_IDENTITY()

END
