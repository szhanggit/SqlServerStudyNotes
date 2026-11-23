-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spQueryNotMarshalledSendinBlueDLRInfoByWhatDate
	-- Add the parameters for the stored procedure here
    @WhatDate DateTime
AS
    BEGIN
		SET NOCOUNT ON;
		DECLARE @tempDate datetime
		SET @tempDate = CONVERT(varchar(100), @WhatDate, 23)
			
		SELECT * FROM dbo.SendinBlueDLR DLR with(nolock) WHERE CONVERT(varchar(100), DLR.WhatDate, 23) = @tempDate AND DLR.[STATUS] = 1;
    END
