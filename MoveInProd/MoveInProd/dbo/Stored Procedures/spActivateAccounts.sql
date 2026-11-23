-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/12/18
-- Description:	Activate multiple accounts.
-- =============================================
CREATE PROCEDURE [dbo].[spActivateAccounts]
	@OrderId					INT,
	@IsSuccess					BIT		OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		DECLARE @CurrentDateTime DATETIME
		SET @CurrentDateTime = CURRENT_TIMESTAMP

		UPDATE OBI 
		SET [ActiveDate] = @CurrentDateTime
		FROM [dbo].[OrderBeneficiaryInfo] OBI
		INNER JOIN [dbo].[OrderLine] OL ON OBI.OrderLineId = OL.Id
		WHERE OL.OrderId = @OrderId AND ([ActiveDate] IS NULL OR [ActiveDate] < '1900-1-1 00:00:01')

		SET @IsSuccess = 1
	END TRY
	BEGIN CATCH
		SET @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

