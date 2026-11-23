-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spCheckBatchActivateAccount
	-- Add the parameters for the stored procedure here
	@StartSequenceNumber BIGINT, 
	@EndSequenceNumber BIGINT,
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
    
	IF(EXISTS(
			SELECT 1 FROM [dbo].[AccountBatchActivateInfo]
			WHERE ([StartSequenceNumber] <= @StartSequenceNumber AND [EndSequenceNumber] >= @StartSequenceNumber)
			OR ([StartSequenceNumber] <= @EndSequenceNumber AND [EndSequenceNumber] >= @EndSequenceNumber)
			OR ([StartSequenceNumber] >= @StartSequenceNumber AND [EndSequenceNumber] <= @EndSequenceNumber)
		))
	     SET @IsSuccess = 1
	  ELSE
	     SET @IsSuccess = 0
END
