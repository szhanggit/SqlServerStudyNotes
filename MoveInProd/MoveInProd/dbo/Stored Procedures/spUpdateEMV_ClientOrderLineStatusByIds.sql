
Create PROCEDURE spUpdateEMV_ClientOrderLineStatusByIds
	@Ids UpdateEMV_ClientOrderLineStatusType Readonly,
	@Status TINYINT = NULL
AS
BEGIN

IF @Status IS NOT NULL
BEGIN
	update ecol set ecol.[Status] = @Status, ecol.OrderNumber=i.OrderNumber
	From [dbo].[EMV_ClientOrderLine] ecol
	join @Ids i on ecol.Id =i.ClientOrderLineId
END

END
