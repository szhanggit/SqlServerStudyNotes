
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spDoubleCheckBatchActivateAccount
	-- Add the parameters for the stored procedure here
	@StartSequenceNumber BIGINT, 
	@EndSequenceNumber BIGINT,
	@Id BIGINT,
	@IsSuccess BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    
	-- Case-One:|_____________|
	--					|______________|

	--SELECT 1 FROM [dbo].[AccountBatchActivateInfo]
	--WHERE [StartSequenceNumber] <= @StartSequenceNumber AND [EndSequenceNumber] >= @StartSequenceNumber

	-- Case-Two:|_____________|
	--		|___________|

	--SELECT 1 FROM [dbo].[AccountBatchActivateInfo]
	--WHERE [StartSequenceNumber] <= @EndSequenceNumber AND [EndSequenceNumber] >= @EndSequenceNumber

	-- Case-Three:|________|
	--		  |_________________|

	--SELECT 1 FROM [dbo].[AccountBatchActivateInfo]
	--WHERE [StartSequenceNumber] >= @StartSequenceNumber AND [EndSequenceNumber] <= @EndSequenceNumber

	IF (@StartSequenceNumber > @EndSequenceNumber)
	BEGIN
		SET @IsSuccess = 1
		RETURN @IsSuccess
	END

	IF (@StartSequenceNumber >=8698000000 AND @EndSequenceNumber <=8698000499)
	BEGIN
		SET @IsSuccess = 0
		RETURN @IsSuccess
	END
    
	IF(EXISTS(
			SELECT 1 FROM [dbo].[AccountBatchActivateInfo]
			WHERE (([StartSequenceNumber] <= @StartSequenceNumber AND [EndSequenceNumber] >= @StartSequenceNumber)
			OR ([StartSequenceNumber] <= @EndSequenceNumber AND [EndSequenceNumber] >= @EndSequenceNumber)
			OR ([StartSequenceNumber] >= @StartSequenceNumber AND [EndSequenceNumber] <= @EndSequenceNumber))
			AND Id != @Id
		))
	     SET @IsSuccess = 1
	  ELSE
	     SET @IsSuccess = 0
END
