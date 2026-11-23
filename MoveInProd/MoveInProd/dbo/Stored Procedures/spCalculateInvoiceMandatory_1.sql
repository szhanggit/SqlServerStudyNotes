-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/08/19
-- Description:	Calculate invoice mandatory.
-- =============================================
CREATE PROCEDURE [dbo].[spCalculateInvoiceMandatory]
	@DateFrom				int
	,@DateTo				int
	,@ClientId				int
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
			INNER JOIN [dbo].[ClientQuotation] CQ ON CQPT.[ClientQuotationId] = CQ.Id AND CQ.ClientId = @ClientId
			INNER JOIN [dbo].[BusinessModelTransactionType] BMTT ON CQP.[TransactionTypeId] = BMTT.[TransactionTypeId] AND BMTT.BusinessModelId = CQ.BusinessModelId
			WHERE T.InvoiceToBeRequestedId IS NULL AND T.ResponseCode = '0000' AND T.TranLocalDate >= @DateFrom AND T.TranLocalDate <= @DateTo) AS S
		GROUP BY ClientQuotationId,OrderId) AS L

		UPDATE [dbo].[Transaction]
		SET [InvoiceToBeRequestedId] = ITBR.Id
		FROM [dbo].[InvoiceToBeRequested] ITBR
		INNER JOIN [dbo].[ClientQuotationProduct] CQPT ON ITBR.ClientQuotationId = CQPT.ClientQuotationId
		INNER JOIN [dbo].[Transaction] T ON ITBR.OrderId = T.OrderId AND CQPT.Id = T.ClientQuotationProductId AND T.InvoiceToBeRequestedId IS NULL
		INNER JOIN [dbo].[Dictionary] D ON T.TranType = D.Name AND D.Category = 'TransactionType'
		INNER JOIN [dbo].[ClientQuotationPricing] CQP ON T.ClientQuotationProductId = CQP.ClientQuotationProductId AND D.Id = CQP.TransactionTypeId
		WHERE ITBR.CreatedOn = @CurrentDateTime AND T.TranLocalDate >= @DateFrom AND T.TranLocalDate <= @DateTo And T.ResponseCode = '0000'

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

