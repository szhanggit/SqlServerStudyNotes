
CREATE PROCEDURE spUpdateEMV_ClientOrderLineStatus
	@ClientOrderLineId INT,
	@Status TINYINT = NULL,
	@OrderNumber VARCHAR(50)
AS
BEGIN

IF @Status IS NOT NULL
BEGIN
	update [dbo].[EMV_ClientOrderLine] set [Status] = @Status, OrderNumber=@OrderNumber WHERE Id = @ClientOrderLineId
END

END
