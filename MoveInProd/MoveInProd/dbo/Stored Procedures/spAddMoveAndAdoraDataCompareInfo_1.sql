
CREATE PROCEDURE spAddMoveAndAdoraDataCompareInfo 
	@MoveAmount BIGINT,
	@AdoraAmount BIGINT,
	@IsGenerateFile BIT,
	@CompareDateInt BIGINT
AS
BEGIN

	SET NOCOUNT ON;
		
	DECLARE @IsEqual BIT

	SET @IsEqual = 0

	IF(@MoveAmount = @AdoraAmount)
	BEGIN
		SET @IsEqual = 1
	END
	   
	INSERT INTO [dbo].[MoveAndAdoraDataCompareInfo]
           ([MoveAmount]
           ,[AdoraAmount]
           ,[IsEqual]
		   ,[IsGenerateFile]
           ,[CompareDateInt]
           ,[CreatedOn]
           ,[LastUpdate])
     VALUES
           (@MoveAmount
           ,@AdoraAmount
           ,@IsEqual
		   ,@IsGenerateFile
           ,@CompareDateInt
           ,GETDATE()
           ,GETDATE())
	
END
