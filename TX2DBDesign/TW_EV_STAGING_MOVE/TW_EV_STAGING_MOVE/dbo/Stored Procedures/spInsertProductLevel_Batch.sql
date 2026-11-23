
CREATE PROCEDURE [dbo].[spInsertProductLevel_Batch]
	@FileName NVARCHAR (300),
	@FileSource NVARCHAR (20),
	@CreatedTime DATETIME,
	@FileType INT,
	@TotalRows INT,
	@Status INT,
	@UpdatedBy VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ProductLevel_Batch]
		(
		[FileName],
		[FileSource],
		[CreatedTime],
		[FileType],
		[TotalRows],
		[Status],
		[UpdatedBy]
		)
	VALUES
		(
			@FileName,
			@FileSource,
			@CreatedTime,
			@FileType,
			@TotalRows,
			@Status,
			@UpdatedBy
	)

	SELECT SCOPE_IDENTITY()
END
