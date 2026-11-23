
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spINGetResendVoucher 
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50),
	@VoucherGUIDs VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(max);


	
	SET @sql = '
		SELECT T1.VoucherNumber
			,T3.[Id] AS OrderLineId
			,T2.[Mobile]
			,T2.[Email] 
			,T1.[GUID] AS [VoucherGUID]
			,T1.[DistributionEmailStatus]
			,T1.[DistributionEmailMemo]
			,T1.[DistributionSLMSStatus]
			,T1.[DistributionSLMSMemo]
		FROM Voucher AS T1 WITH(NOLOCK)
			JOIN [dbo].[OrderBeneficiaryInfo] AS T2 WITH(NOLOCK) ON T1.BeneficiaryInfoId = T2.Id
			JOIN [dbo].[OrderLine] AS T3 WITH(NOLOCK) ON T2.OrderLineId = T3.Id
			JOIN [dbo].[Order] AS T4  WITH(NOLOCK) ON T3.[OrderId] = T4.Id
		WHERE T4.OrderNumber = '''+@OrderNumber+'''
			AND T1.[GUID] IN (@VoucherGUIDs)'

	PRINT @sql

	SET @sql = REPLACE(@sql,'@VoucherGUIDs',@VoucherGUIDs);
	exec sp_executesql @sql	

END
