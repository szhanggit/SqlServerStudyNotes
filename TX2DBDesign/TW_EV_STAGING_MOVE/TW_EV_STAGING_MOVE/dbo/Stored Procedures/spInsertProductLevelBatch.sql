
CREATE PROCEDURE [dbo].[spInsertProductLevelBatch]
	@BatchNo VARCHAR(20),
	@TotalProductCount INT,
	@CreatedBy VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ProductLevelBatch]
	(
		[BatchNo], 
		[TotalProductCount], 
		[CreatedBy]
	)
	VALUES
	(
		@BatchNo,
		@TotalProductCount,
		@CreatedBy
	)

	SELECT SCOPE_IDENTITY()
END
