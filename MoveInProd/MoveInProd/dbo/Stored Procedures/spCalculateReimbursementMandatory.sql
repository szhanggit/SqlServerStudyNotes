-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/08/26
-- Description:	Calculate reimbursement mandatory.
-- =============================================
CREATE PROCEDURE [dbo].[spCalculateReimbursementMandatory]
	@DateFrom				int
	,@DateTo				int
	,@IsSuccess				bit			output
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
			WHERE T.SettleDate <= @DateTo AND T.SettleDate >= @DateFrom AND T.ReimbursementLineId IS NULL AND T.ResponseCode='0000') AS S
		GROUP BY [SettleDate],[ReimbursementSchemeId],[Cost],[ProductId],[ClientQuotationProductId]

		UPDATE [dbo].[Transaction]
		SET [ReimbursementLineId] = RL.Id
		FROM [dbo].[ReimbursementLine] RL
		INNER JOIN [dbo].[Transaction] T ON RL.ReimbursementSchemeId = T.ReimbursementSchemeId AND RL.SettleDate = T.SettleDate
		WHERE RL.CreatedOn = @CurrentDateTime
		  AND T.ReimbursementLineId IS NULL
		set @IsSuccess = 1
	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END

