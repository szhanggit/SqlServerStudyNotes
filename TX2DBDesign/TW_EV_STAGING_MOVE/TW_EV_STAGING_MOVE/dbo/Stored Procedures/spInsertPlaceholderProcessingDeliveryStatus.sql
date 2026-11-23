
CREATE PROCEDURE spInsertPlaceholderProcessingDeliveryStatus
    @VoucherId bigint ,
    @MessageType int ,
    @dtime datetime
AS
    BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
        SET NOCOUNT ON;
		DECLARE @MaxDistributionTaskMessageId bigint;
		IF(@MessageType = 1)
        BEGIN
			SET @MaxDistributionTaskMessageId = (select max(dtmv.DistributionTaskMessageId) FROM dbo.DistributionTask dt with(NOLOCK)
			INNER JOIN dbo.DistributionTaskMessage dtm with(NOLOCK) ON dt.Id = dtm.DistributionTaskId
			INNER JOIN dbo.DistributionTaskMessageVoucher dtmv with(NOLOCK) ON dtm.Id = dtmv.DistributionTaskMessageId
			where dtmv.voucherid = @VoucherId
			AND dt.MessageType = 1 )
			
            INSERT INTO dbo.DistributionEmailMessageStatus(ExternalId,DistributionTaskMessageId,SendStatus,OriginalStatus,[Description],CreatedTime,OriginalTime)
			SELECT TOP 1 NULL,
            @MaxDistributionTaskMessageId,
            4 AS SendStatus,
            'Processing' AS OriginalStatus,
            'Resending after Update Beneficiary Info' AS Description,
            @dtime AS CreatedTime,
            dems.OriginalTime AS OriginalTime
            FROM dbo.DistributionTask dt with(NOLOCK)
			INNER JOIN dbo.DistributionTaskMessage dtm with(NOLOCK) ON dt.Id = dtm.DistributionTaskId
			INNER JOIN dbo.DistributionTaskMessageVoucher dtmv with(NOLOCK) ON dtm.Id = dtmv.DistributionTaskMessageId
            LEFT JOIN dbo.DistributionEmailMessageStatus dems with(NOLOCK) ON dtmv.DistributionTaskMessageId = dems.DistributionTaskMessageId
            WHERE dtmv.VoucherId= @VoucherId AND dt.MessageType =1
			AND dems.DistributionTaskMessageId IS NOT NULL
            ORDER BY dems.OriginalTime,dems.CreatedTime DESC
        END
        ELSE IF(@MessageType = 2)
        BEGIN
			SET @MaxDistributionTaskMessageId = (SELECT max(dtmv.DistributionTaskMessageId) FROM dbo.DistributionTask dt with(NOLOCK)
			INNER JOIN dbo.DistributionTaskMessage dtm with(NOLOCK) ON dt.Id = dtm.DistributionTaskId
			INNER JOIN dbo.DistributionTaskMessageVoucher dtmv with(NOLOCK) ON dtm.Id = dtmv.DistributionTaskMessageId
			where dtmv.voucherid = @VoucherId
			AND dt.MessageType = 2 )
			
            INSERT INTO dbo.DistributionSLMSMessageStatus(ExternalId,DistributionTaskMessageId,SendStatus,OriginalStatus,[Description],CreatedTime,OriginalTime)
            SELECT TOP 1 NULL,
            @MaxDistributionTaskMessageId,
            4 AS SendStatus,
            '99' AS OriginalStatus,--Processing
            'Resending after Update Beneficiary Info' AS Description,
            @dtime AS CreatedTime,
            dsms.OriginalTime AS OriginalTime
            FROM dbo.DistributionTask dt with(NOLOCK)
			INNER JOIN dbo.DistributionTaskMessage dtm with(NOLOCK) ON dt.Id = dtm.DistributionTaskId
			INNER JOIN dbo.DistributionTaskMessageVoucher dtmv with(NOLOCK) ON dtm.Id = dtmv.DistributionTaskMessageId
            LEFT JOIN dbo.DistributionSLMSMessageStatus dsms with(NOLOCK) ON dtmv.DistributionTaskMessageId = dsms.DistributionTaskMessageId
            WHERE dtmv.VoucherId= @VoucherId AND dt.MessageType =2
			AND dsms.DistributionTaskMessageId IS NOT NULL
            ORDER BY dsms.OriginalTime,dsms.CreatedTime DESC
        END

    END;
