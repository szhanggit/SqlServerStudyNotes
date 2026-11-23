
CREATE PROCEDURE spArchivePublishedBuffer
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @orderId INT = (SELECT TOP (1) Id FROM dbo.[Order] WITH(NOLOCK) WHERE [Status] = 64  AND Mode <> 2 AND PublishDatetime > DATEADD(DAY, -3, GETDATE()) ORDER BY Id);

	WHILE @orderId IS NOT NULL
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.VoucherOrderBuffer WITH(NOLOCK) WHERE OrderId = @orderId)
		BEGIN
			DELETE dbo.VoucherBuffer WHERE OrderId = @orderId

			DELETE dbo.VoucherOrderBuffer 
				OUTPUT Deleted.OrderId,Deleted.OrderLineId,Deleted.OrderBeneficiaryInfoId,Deleted.OrderSN,Deleted.OrderLineSN,
					Deleted.OrderBeneficiaryInfoSN,Deleted.VoucherNumber,Deleted.AdoraTaskId,Deleted.CreationTime,Deleted.SessionId
				INTO dbo.VoucherOrderBufferHistory(OrderId,OrderLineId,OrderBeneficiaryInfoId,OrderSN,OrderLineSN,OrderBeneficiaryInfoSN,VoucherNumber,AdoraTaskId,CreationTime,SessionId)
				WHERE OrderId = @orderId
			
			WAITFOR DELAY '00:00:01'
		END

		SET @orderId =  (SELECT TOP (1) Id FROM dbo.[Order] WITH(NOLOCK) WHERE [Status] = 64  AND Mode <> 2 AND Id > @orderId ORDER BY Id);
	END 
END
