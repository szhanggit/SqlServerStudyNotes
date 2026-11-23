
CREATE PROCEDURE spGetMoveAndAdoraDataCompareInfo 
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
	  FROM [dbo].[MoveAndAdoraDataCompareInfo]
	  WHERE CompareDateInt = @CompareDate
	
END
