-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateBeneficiaryMember]
	-- Add the parameters for the stored procedure here
	@OrderId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRAN

		UPDATE OrderBeneficiaryInfo
		SET MemberId = m.Id
		FROM Member m
		JOIN OrderBeneficiaryInfo obi ON m.Mobile = obi.Mobile
		JOIN OrderLine ol ON ol.Id = obi.OrderLineId
		WHERE ol.OrderId = @OrderId

		IF @@ROWCOUNT > 0
			COMMIT TRAN
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN
	END CATCH
END

