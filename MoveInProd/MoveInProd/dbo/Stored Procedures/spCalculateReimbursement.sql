-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/08/12
-- Description:	Calculate Reimbursement.
-- =============================================
CREATE PROCEDURE [dbo].[spCalculateReimbursement]
	@Today					INT
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		DECLARE @CurrentDateTime DATETIME
		SET @CurrentDateTime=CURRENT_TIMESTAMP

		INSERT INTO [dbo].[ReimbursementLine]
			([SettleDate]
			,[ReimbursementSchemeId]
			,[TransactionCount]
			,[Cost]
			,[ReimbursementAmount]
			,[Status]
			,[CreatedOn]
			,[ProductId]
			,[ClientQuotationProductId])
		SELECT [SettleDate]
			,[ReimbursementSchemeId]
			,COUNT([SettleDate])
			,[Cost]
			,SUM([ReimbursementValue])
			,1
			,@CurrentDateTime
			,[ProductId]
			,[ClientQuotationProductId]
		FROM (
			SELECT [SettleDate],[ReimbursementSchemeId]
					,(CASE P.ProductType WHEN 1 THEN RS.Value
										 WHEN 2 THEN RS.Value / 100 END) AS Cost
					,[ReimbursementValue]
					,[ProductId]
					,[ClientQuotationProductId]
			FROM [dbo].[Transaction] T
			INNER JOIN [dbo].[ReimbursementScheme] RS ON RS.Id = T.ReimbursementSchemeId
			INNER JOIN [dbo].[Product] P ON T.[ProductId] = P.Id
			WHERE T.SettleDate < @Today AND T.ReimbursementLineId IS NULL AND T.ResponseCode='0000') AS S
		GROUP BY [SettleDate],[ReimbursementSchemeId],[Cost],[ProductId],[ClientQuotationProductId]

		UPDATE [dbo].[Transaction]
		SET [ReimbursementLineId] = RL.Id
		FROM [dbo].[ReimbursementLine] RL
		INNER JOIN [dbo].[Transaction] T ON RL.ReimbursementSchemeId = T.ReimbursementSchemeId AND RL.SettleDate=T.SettleDate
		WHERE RL.CreatedOn = @CurrentDateTime
		  AND T.ReimbursementLineId IS NULL
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

