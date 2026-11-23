-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetOrderBeneficiaryInfoByOrderNumber] 
	-- Add the parameters for the stored procedure here
	@OrderNumber varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT T4.VoucherNumber
		,T7.ProductCode
		,ISNULL(T1.Email,'') AS Email
		,ISNULL(T1.Mobile,'') AS Mobile
	FROM [dbo].[OrderBeneficiaryInfo] AS T1 WITH (NOLOCK)
		INNER JOIN [dbo].[OrderLine] AS T2 WITH (NOLOCK) ON T1.[OrderLineId] = T2.Id
		INNER JOIN [dbo].[Order] AS T3 WITH (NOLOCK) ON T2.[OrderId] = T3.Id
		INNER JOIN [dbo].[Voucher] AS T4 WITH (NOLOCK) ON T4.[BeneficiaryInfoId] = T1.Id
		INNER JOIN [dbo].[ClientQuotationProduct] AS T5 WITH (NOLOCK) ON T2.[ClientQuotationProductId] = T5.Id
		INNER JOIN [dbo].[ProductVersion] AS T6 WITH (NOLOCK) ON T5.[ProductVersionId] = T6.Id
		INNER JOIN [dbo].[Product] AS T7 WITH (NOLOCK) ON T6.[ProductId] = T7.Id
	WHERE T3.[OrderNumber] = @OrderNumber
END
