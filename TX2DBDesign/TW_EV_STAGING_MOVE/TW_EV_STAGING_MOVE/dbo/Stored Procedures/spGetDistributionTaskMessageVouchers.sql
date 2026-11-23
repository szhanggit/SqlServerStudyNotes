
CREATE PROCEDURE [dbo].[spGetDistributionTaskMessageVouchers]
    @DistributionTaskId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  dtmv.VoucherId ,
                dtmv.DistributionTaskMessageId
        FROM    dbo.DistributionTask AS dt WITH ( NOLOCK )
                INNER JOIN dbo.DistributionTaskMessage AS dtm WITH ( NOLOCK ) ON dtm.DistributionTaskId = dt.Id
                INNER JOIN dbo.DistributionTaskMessageVoucher AS dtmv WITH ( NOLOCK ) ON dtmv.DistributionTaskMessageId = dtm.Id
        WHERE   dt.Id = @DistributionTaskId
    END
