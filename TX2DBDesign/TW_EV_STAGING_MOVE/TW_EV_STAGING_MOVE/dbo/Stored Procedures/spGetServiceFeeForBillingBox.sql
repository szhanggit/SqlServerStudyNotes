-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetServiceFeeForBillingBox 
	-- Add the parameters for the stored procedure here
	@DATETIME DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DateInt INT

	SET @DateInt = CONVERT(INT,CONVERT(VARCHAR(100), @DATETIME, 112))
    -- Insert statements for procedure here
	SELECT t1.Id,
		t3.Id AS [TransactionId],
		t2.Id AS [ServiceFeeId],
		t4.Name AS [ServiceFeeName],
		t1.TranFee,
		isnull(t1.TranFeeWithTax,T5.SoldPriceWithTax) as [TranFeeWithTax],
		cqp.ClientQuotationId as [QuotationId]
	FROM dbo.TransactionFee t1 WITH(NOLOCK) 
		INNER JOIN dbo.ServiceFee t2 WITH(NOLOCK) ON t1.ServiceFeeId = t2.Id
		INNER JOIN dbo.[Transaction] t3 WITH(NOLOCK) ON t1.TransactionId = t3.Id
		INNER JOIN dbo.Dictionary t4 WITH(NOLOCK) ON t2.ServiceFeeNameId = t4.Id
		INNER JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T5 WITH(NOLOCK) ON T5.ClientQuotationProductId = T3.ClientQuotationProductId
		INNER JOIN dbo.ClientQuotationProduct cqp with(nolock) ON t3.ClientQuotationProductId = cqp.Id
		INNER JOIN ServiceFeeTriggerTime T6 WITH(NOLOCK) ON T5.ServiceFeeTriggerTimeId = T6.Id  AND t6.ServiceFeeId = t1.ServiceFeeId AND t6.TranType = t3.TranType	
	WHERE t3.TranLocalDate = @DateInt
		AND T5.ValidityFrom <= @DATETIME
		AND T5.ValidityEnd >= @DATETIME
		AND T5.Status = 2
		AND ISNULL(t1.IsValid,1) = 1
END