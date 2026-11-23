
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetVoucherImpTempBySessionId 
	-- Add the parameters for the stored procedure here
	@SessionId VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		SessionId
		, ProductId
		, ProgramId
		, VoucherNumber
		, BalanceAvailable
		, [Status]
		, ReservationBatchId
		, CreationTime
		, ExpiryDate
		, PinCode
	FROM VoucherImpTemp
	WHERE SessionId = @SessionId
END
