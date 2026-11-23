-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spQueryNotFetchedDLRInfoByWhatDate
	-- Add the parameters for the stored procedure here
    @WhatDate DateTime NULL
AS
    BEGIN
		SET NOCOUNT ON;
		DECLARE @tempDate datetime
		declare @n int
		set @n=0
		SET @tempDate = CONVERT(varchar(100), @WhatDate, 23)
		CREATE TABLE #Temp_Table
		(
			WhatDate DateTime,
            Fromhour INT,
            Tohour INT
        )
		INSERT INTO #Temp_Table(WhatDate,Fromhour,Tohour) VALUES(@WhatDate, 23, 0);

		while @n < 23
		begin
			INSERT INTO #Temp_Table(WhatDate,Fromhour,Tohour) VALUES(@WhatDate, @n, @n + 1);
		    select @n=@n+1
		end
		
		SELECT CONVERT(varchar(100), WhatDate, 23),Fromhour,Tohour FROM #Temp_Table
		MINUS
		SELECT DISTINCT CONVERT(varchar(100), WhatDate, 23),Fromhour,Tohour FROM dbo.NetCoreDLR nDLR with(nolock) WHERE CONVERT(varchar(100), nDLR.WhatDate, 23) = @tempDate;
    END;
