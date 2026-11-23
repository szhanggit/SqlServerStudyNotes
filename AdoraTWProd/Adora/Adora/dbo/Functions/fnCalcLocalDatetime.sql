
-- =============================================
-- Author:		Knight YAO
-- Create date: 2015/10/09
-- Description:	Calculate local datetime
-- =============================================
CREATE FUNCTION [dbo].[fnCalcLocalDatetime]
(
	@UtcDateTime	DATETIME
	,@TimeOffset	VARCHAR(6)
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @ReturnValue DATETIME

	IF(SUBSTRING(@TimeOffset, 1, 1) = '-')
		SET @ReturnValue = @UtcDateTime - SUBSTRING(@TimeOffset, 2, LEN(@TimeOffset)-1)
	ELSE
		SET @ReturnValue = @UtcDateTime + @TimeOffset

	RETURN @ReturnValue
END
