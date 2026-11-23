
-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/5/23
-- Description:	Calculate local date
-- =============================================
CREATE FUNCTION [dbo].[fnCalcLocalDate]
(
	@UtcDateTime	DATETIME
	,@TimeOffset	VARCHAR(6)
)
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @ReturnValue VARCHAR(8)

	IF(SUBSTRING(@TimeOffset, 1, 1) = '-')
		SET @ReturnValue = CONVERT(VARCHAR(8),@UtcDateTime - SUBSTRING(@TimeOffset, 2, LEN(@TimeOffset)-1),112)
	ELSE
		SET @ReturnValue = CONVERT(VARCHAR(8),@UtcDateTime + @TimeOffset,112)

	RETURN @ReturnValue
END

