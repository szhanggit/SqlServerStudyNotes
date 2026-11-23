

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[spCheckExistNoApprovePrice]
	@QuotationNumber VARCHAR(50)
	,@DateTime Datetime
	,@ProductCode VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	SELECT 1
	FROM [dbo].[ClientQuotationProduct] AS T1
	INNER JOIN [dbo].[ClientQuotationProductSoldPrice] AS T2 ON T2.ClientQuotationProductId = T1.Id
	LEFT  JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T3 ON T3.ClientQuotationProductId = T1.Id
	INNER JOIN [dbo].[ClientQuotation] AS T4 ON T1.ClientQuotationId = T4.Id					
	INNER JOIN [dbo].[ProductVersion] AS T6 ON T1.ProductVersionId = T6.Id
	INNER JOIN [dbo].[Product] AS T7 ON T6.ProductId = T7.Id
	WHERE T4.QuotationNumber = @QuotationNumber
	AND T7.ProductCode = @ProductCode
	AND (
		(T2.ValidityFrom <= @DateTime AND T2.ValidityEnd >= @DateTime AND T2.[Status] = 1)
		OR 
		(T3.ValidityFrom <= @DateTime AND T3.ValidityEnd >= @DateTime AND T3.[Status] = 1)
		)

END


