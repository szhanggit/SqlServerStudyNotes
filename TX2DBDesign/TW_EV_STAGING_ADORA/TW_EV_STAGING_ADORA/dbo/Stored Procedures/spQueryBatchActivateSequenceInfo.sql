
CREATE PROCEDURE spQueryBatchActivateSequenceInfo
	@StartSeq BIGINT, 
	@EndSeq BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT SequenceNumber,CreatedUTCTime FROM [AccountBatchActivateRecords] WHERE SequenceNumber >= @StartSeq AND SequenceNumber <= @EndSeq;
END
