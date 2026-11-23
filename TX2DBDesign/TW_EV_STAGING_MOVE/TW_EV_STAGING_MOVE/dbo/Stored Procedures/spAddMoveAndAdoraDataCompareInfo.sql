
CREATE PROCEDURE [dbo].[spAddMoveAndAdoraDataCompareInfo] 
	@MoveAmount BIGINT,
	@AdoraAmount BIGINT,
	@IsGenerateFile BIT,
	@CompareDateInt BIGINT,
	@MoveAndAdoraDataCompareInfoId INT OUTPUT
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
           ,[LastUpdate]
		   ,[IsDataCorrect])
     VALUES
           (@MoveAmount
           ,@AdoraAmount
           ,@IsEqual
		   ,@IsGenerateFile
           ,@CompareDateInt
           ,GETDATE()
           ,GETDATE()
		   ,0)
	
	SELECT @MoveAndAdoraDataCompareInfoId = SCOPE_IDENTITY()
END
