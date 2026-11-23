
CREATE PROCEDURE [dbo].[spIsFetchedWhatDateForSendinBlueDLR]
@WhatDate datetime,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @tempDate datetime
    set @IsSuccess = 0;
	SET @tempDate = CONVERT(varchar(100), @WhatDate, 23)
	
	IF EXISTS (SELECT 1 FROM SendinBlueDLR sDLR WITH(NOLOCK) WHERE CONVERT(varchar(100), sDLR.WhatDate, 23) = @tempDate)
	BEGIN
		set @IsSuccess = 1;
	END
END
