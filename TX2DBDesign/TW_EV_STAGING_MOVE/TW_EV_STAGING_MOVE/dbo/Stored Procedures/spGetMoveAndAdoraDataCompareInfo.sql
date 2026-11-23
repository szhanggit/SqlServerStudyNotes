
CREATE PROCEDURE [dbo].[spGetMoveAndAdoraDataCompareInfo] 
	@CompareDate INT
AS
BEGIN

	SET NOCOUNT ON;
			
	SELECT [Id]
		  ,[MoveAmount]
		  ,[AdoraAmount]
		  ,[IsEqual]
		  ,[IsGenerateFile]
		  ,[CompareDateInt]
		  ,[CreatedOn]
		  ,[LastUpdate]
		  ,[IsDataCorrect]
	  FROM [dbo].[MoveAndAdoraDataCompareInfo]
	  WHERE CompareDateInt = @CompareDate
	
END
