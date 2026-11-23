-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/15
-- Description:	Get sequence numbers.
-- =============================================
CREATE PROCEDURE spGetSequenceNumbers
	@Count			INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #SequenceNumber (SequenceNumber varchar(9))

	declare @HostSsn varchar(9)

	WHILE(@Count > 0)
	BEGIN
	   set @HostSsn = next value for HostSsn_Sequence

	   INSERT INTO #SequenceNumber (SequenceNumber)
	   SELECT right(replicate('0',9)+@HostSsn,9)

	   SET @Count = @Count - 1
	END

	SELECT SequenceNumber FROM #SequenceNumber

	DROP TABLE #SequenceNumber
END
