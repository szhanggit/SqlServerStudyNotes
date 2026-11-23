-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCheckQuotationProductNeedApprove] 
	-- Add the parameters for the stored procedure here
	@QuotationNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT 1
	FROM [dbo].[ClientQuotationProduct] AS T1 WITH (NOLOCK)
		INNER JOIN [dbo].[ClientQuotation] AS T2 WITH (NOLOCK) ON T1.ClientQuotationId = T2.Id
		LEFT JOIN [dbo].[ClientQuotationProductSoldPrice] AS T3 WITH (NOLOCK) ON T1.[Id] = T3.ClientQuotationProductId
		LEFT JOIN [dbo].[ClientQuotationProductServiceFeeTriggerTime] AS T4 WITH (NOLOCK) ON T1.[Id] = T4.ClientQuotationProductId
	WHERE T2.QuotationNumber = @QuotationNumber
		AND (T1.[Status] < 32 OR (T1.[Status] = 32 AND (T3.[Status] = 1 OR T4.[Status] = 1)))

END

