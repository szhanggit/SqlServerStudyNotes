
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spQueryNotFetchedDLRInfoForEmail]
	-- Add the parameters for the stored procedure here
    @WhatDate DateTime
AS
    BEGIN
		SET NOCOUNT ON;
		DECLARE @tempDate datetime
		SET @tempDate = CONVERT(varchar(100), @WhatDate, 23)

		SELECT
			CONVERT(varchar(100), WhatDate, 23) AS WhatDate,Fromhour,Tohour
		FROM dbo.NetCoreDLR nDLR with(nolock)
		WHERE CONVERT(varchar(100), nDLR.WhatDate, 23) = @tempDate
		AND DLRType = 1 -- EMAIL
    END;
