
CREATE PROCEDURE [dbo].[spInsertProductProcurementTriggerSetting]
	@ProductId INT,
	@ProcurementQty INT,
	@NeedProcurementTrigger BIT,
	@UserName VARCHAR(50)
AS
BEGIN
	IF EXISTS(SELECT 1
	FROM ProductProcurementTriggerSetting
	WHERE Id = @ProductId)
	BEGIN
		UPDATE ProductProcurementTriggerSetting
		SET
			ProcurementQty = @ProcurementQty,
			NeedProcurementTrigger = @NeedProcurementTrigger,
			ModifiedBy = @UserName,
			ModifiedOn = GETDATE()
		WHERE Id = @ProductId
	END
	ELSE
	BEGIN
		INSERT INTO ProductProcurementTriggerSetting
			(Id, ProcurementQty, NeedProcurementTrigger, CreatedBy, CreatedOn)
		VALUES
			(@ProductId, @ProcurementQty, @NeedProcurementTrigger, @UserName, GETDATE())
	END
END
