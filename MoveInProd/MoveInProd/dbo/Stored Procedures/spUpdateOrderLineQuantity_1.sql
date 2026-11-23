
CREATE PROCEDURE [dbo].[spUpdateOrderLineQuantity] 
   @OrderLineId INT
	,@QuantityToAdd INT
	,@EmailQuantityToAdd INT
	,@SLMSQuantityToAdd INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	UPDATE OrderLine
	SET TotalQuantity = TotalQuantity + @QuantityToAdd
	   ,EmailQuantity = EmailQuantity + @EmailQuantityToAdd
	   ,SLMSQuantity = SLMSQuantity + @SLMSQuantityToAdd
	WHERE ID=@OrderLineId

	IF @@ERROR <> 0
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN
END

