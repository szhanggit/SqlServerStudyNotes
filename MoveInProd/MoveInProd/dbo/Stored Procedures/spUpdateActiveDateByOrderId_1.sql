
CREATE PROCEDURE [dbo].[spUpdateActiveDateByOrderId] @ActiveDate DATETIME
	,@OrderId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		UPDATE obi
		SET obi.ActiveDate = @ActiveDate
		FROM OrderBeneficiaryInfo obi
		JOIN OrderLine ol ON obi.OrderLineId = ol.Id
		WHERE ol.OrderId = @OrderId
	END TRY

	BEGIN CATCH
			ROLLBACK TRAN
		  RETURN
	END CATCH

	COMMIT TRAN
END

