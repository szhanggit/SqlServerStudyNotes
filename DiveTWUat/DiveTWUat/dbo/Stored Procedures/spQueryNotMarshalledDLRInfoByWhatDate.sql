-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spQueryNotMarshalledDLRInfoByWhatDate
	-- Add the parameters for the stored procedure here
    @WhatDate DateTime NULL
AS
    BEGIN
		SET NOCOUNT ON;
		DECLARE @tempDate datetime
		SET @tempDate = CONVERT(varchar(100), @WhatDate, 23)
			
		SELECT * FROM dbo.NetCoreDLR nDLR with(nolock) WHERE CONVERT(varchar(100), nDLR.WhatDate, 23) = @tempDate AND nDLR.[STATUS] = 2;
    END
