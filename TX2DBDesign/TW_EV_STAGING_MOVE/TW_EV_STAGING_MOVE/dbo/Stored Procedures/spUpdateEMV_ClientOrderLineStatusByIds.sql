


CREATE PROCEDURE [dbo].[spUpdateEMV_ClientOrderLineStatusByIds]

	@Ids UpdateEMV_ClientOrderLineStatusType Readonly,
	@Status TINYINT = NULL
AS
BEGIN

IF @Status IS NOT NULL
BEGIN
	update ecol 
	set ecol.[Status] = 
			CASE WHEN o.Status = 2048 THEN 3
				ELSE @Status
			END, 
		ecol.OrderNumber=i.OrderNumber
	From [dbo].[EMV_ClientOrderLine] ecol
	join @Ids i on ecol.Id =i.ClientOrderLineId
	left join [Order] o on i.OrderNumber = o.OrderNumber
END

END
