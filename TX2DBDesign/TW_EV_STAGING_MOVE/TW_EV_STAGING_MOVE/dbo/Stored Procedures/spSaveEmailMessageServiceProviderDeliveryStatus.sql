CREATE PROCEDURE [dbo].[spSaveEmailMessageServiceProviderDeliveryStatus]
@InputTable ServiceProviderDeliveryStatusType READONLY,
@IsSuccess bit output
AS
BEGIN
	SET NOCOUNT ON;
	SELECT dtmv.DistributionTaskMessageId,dtmv.VoucherId
	INTO #SelectedVouchersTemp
	FROM dbo.DistributionTask dt with(nolock) INNER JOIN dbo.DistributionTaskMessage dtm with(nolock) ON dt.Id = dtm.DistributionTaskId
	inner join DistributionTaskMessageVoucher dtmv with(nolock) ON dtm.Id = dtmv.DistributionTaskMessageId
	INNER JOIN @InputTable it ON dtmv.DistributionTaskMessageId = it.DistributionTaskMessageId
	WHERE dt.MessageType = 1
	
	INSERT INTO EmailMessageServiceProviderDeliveryStatus(VoucherId,DeliveryStatus,DeliveryTime,CreatedTime) 
	SELECT tt.VoucherId,tt.DeliveryStatus,tt.DeliveryTime, getdate() FROM 
	(
	SELECT DISTINCT temp.VoucherId, it.DeliveryStatus,it.DeliveryTime FROM #SelectedVouchersTemp temp with(nolock) INNER JOIN @InputTable it ON temp.DistributionTaskMessageId = it.DistributionTaskMessageId
	EXCEPT
	SELECT DISTINCT temp.VoucherId, emspds.DeliveryStatus, emspds.DeliveryTime FROM #SelectedVouchersTemp temp with(nolock) INNER JOIN EmailMessageServiceProviderDeliveryStatus emspds with(nolock) ON temp.VoucherId = emspds.VoucherId
	) tt

	set @IsSuccess = 1;
	drop table #SelectedVouchersTemp
END