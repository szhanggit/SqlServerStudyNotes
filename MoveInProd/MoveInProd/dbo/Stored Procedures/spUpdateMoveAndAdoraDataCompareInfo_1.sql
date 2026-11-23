
CREATE PROCEDURE spUpdateMoveAndAdoraDataCompareInfo 
	@Id BIGINT,
	@MoveAmount BIGINT,
	@AdoraAmount BIGINT,
	@IsGenerateFile BIT,
    @IsDataCorrect BIT,
    @Comments NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
		
	DECLARE @IsEqual BIT
	DECLARE @CompareDateInt BIGINT

	SET @IsEqual = 0

	IF(@MoveAmount = @AdoraAmount)
	BEGIN
		SET @IsEqual = 1
	END
	   
	UPDATE [dbo].[MoveAndAdoraDataCompareInfo]
	   SET [MoveAmount] = @MoveAmount
		  ,[AdoraAmount] = @AdoraAmount
		  ,[IsEqual] = @IsEqual
		  ,[IsGenerateFile] = @IsGenerateFile
		  ,[LastUpdate] = GETDATE()
          ,[IsDataCorrect] = @IsDataCorrect
          ,[Comments] = Comments
	 WHERE Id = @Id
	
END
