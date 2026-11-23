
CREATE PROCEDURE [dbo].[spBuildProductProcurementTrigger]
	@ProductId INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1
	FROM ProductProcurementTrigger
	WHERE ProductId = @ProductId and Status in (0,1))
	BEGIN
		INSERT INTO [dbo].[ProductProcurementTrigger]
			([ProductId]
			,[Status]
			,[RetryCount]
			,[CreatedDateTime]
			,[TriggerDateTime]
			,[RetryDateTime]
			,[ClearDateTime]
			,[TriggerResponse])
		VALUES(
				@ProductId
           , 0
           , 0
           , getdate()
           , null
           , null
           , null
           , null)
	END

	SELECT TOP 1
		[Id]
      , [ProductId]
      , [Status]
      , [RetryCount]
      , [CreatedDateTime]
      , [TriggerDateTime]
      , [RetryDateTime]
      , [ClearDateTime]
      , [TriggerResponse]
	FROM [ProductProcurementTrigger] with(nolock)
	WHERE [ProductId] = @ProductId and [Status] in (0,1)
END
