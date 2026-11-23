

-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/18
-- Description:	Delete distribution task messages.
-- =============================================
CREATE PROCEDURE spDeleteDistributionTaskMessages
    @DistributionTaskId BIGINT
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

        DELETE  t1
        FROM    dbo.DistributionTaskMessageVoucher AS t1
                JOIN [dbo].[DistributionTaskMessage] AS t2 ON t2.Id = t1.DistributionTaskMessageId
        WHERE   t2.DistributionTaskId = @DistributionTaskId
	
        DELETE  FROM [dbo].[DistributionTaskMessage]
        WHERE   [DistributionTaskId] = @DistributionTaskId
    END
