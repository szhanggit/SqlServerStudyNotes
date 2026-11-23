-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/08/07
-- Description:	Calculate invoice.
-- =============================================
CREATE PROCEDURE [dbo].[spCalculateInvoice]
	@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		DECLARE @CurrentDateTime DATETIME
		DECLARE @Day TINYINT
		DECLARE @IsEndDayOfMonth BIT
		SET @CurrentDateTime=CURRENT_TIMESTAMP
		SET @Day=CAST(day(@CurrentDateTime) AS TINYINT)
		SET @IsEndDayOfMonth =  CASE WHEN day(DATEADD(day,1,@CurrentDateTime)) = 1 THEN 1 ELSE 0 END;

		INSERT INTO [dbo].[InvoiceToBeRequested]
			   ([ClientQuotationId],[OrderId],[Type],[TotalAmount],[Status],[CreatedOn])
		SELECT ClientQuotationId,OrderId,1,Amount,1,@CurrentDateTime
		FROM (
		SELECT ClientQuotationId,OrderId,SUM(Amount) AS Amount
		FROM (
			SELECT CQPT.ClientQuotationId,T.OrderId,[InvoiceValue] AS Amount
			FROM [dbo].[Transaction] T
			INNER JOIN [dbo].[Dictionary] D ON T.TranType = D.Name AND D.Category = 'TransactionType'
			INNER JOIN [dbo].[ClientQuotationPricing] CQP ON T.ClientQuotationProductId = CQP.ClientQuotationProductId AND D.Id = CQP.TransactionTypeId
			INNER JOIN [dbo].[ClientQuotationProduct] CQPT ON T.ClientQuotationProductId = CQPT.Id
			INNER JOIN [dbo].[ClientQuotation] CQ ON CQPT.[ClientQuotationId] = CQ.Id
			INNER JOIN [dbo].[BusinessModelTransactionType] BMTT ON CQP.[TransactionTypeId] = BMTT.[TransactionTypeId] AND BMTT.BusinessModelId = CQ.BusinessModelId
			INNER JOIN [dbo].[ClientInvoiceCutoffSetting] CICS ON BMTT.[BusinessModelId] = CICS.[BusinessModelId] AND CQ.[ClientId] = CICS.[ClientId]
			LEFT JOIN [dbo].[ClientInvoiceCutoffDay] CICD ON CICS.Id = CICD.[ClientInvoiceCutoffSettingId]
			WHERE T.InvoiceToBeRequestedId IS NULL AND T.ResponseCode = '0000' AND (CICD.[Day] = @Day OR (CICS.[IsEndDayOfMonthCutoff] = 1 AND @IsEndDayOfMonth = 1))) AS S
		GROUP BY ClientQuotationId,OrderId) AS L

		UPDATE [dbo].[Transaction]
		SET [InvoiceToBeRequestedId] = ITBR.Id
		FROM [dbo].[InvoiceToBeRequested] ITBR
		INNER JOIN [dbo].[ClientQuotationProduct] CQPT ON ITBR.ClientQuotationId = CQPT.ClientQuotationId
		INNER JOIN [dbo].[Transaction] T ON ITBR.OrderId = T.OrderId AND CQPT.Id = T.ClientQuotationProductId AND T.InvoiceToBeRequestedId IS NULL
		INNER JOIN [dbo].[Dictionary] D ON T.TranType = D.Name AND D.Category = 'TransactionType'
		INNER JOIN [dbo].[ClientQuotationPricing] CQP ON T.ClientQuotationProductId = CQP.ClientQuotationProductId AND D.Id = CQP.TransactionTypeId
		WHERE ITBR.CreatedOn = @CurrentDateTime
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

