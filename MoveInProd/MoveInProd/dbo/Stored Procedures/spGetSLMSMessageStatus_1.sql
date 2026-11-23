-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetSLMSMessageStatus 
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
	case [OriginalStatus] when 0 then N'預約傳送中'
	when 1 then N'已送達業者'
	when 2 then N'已送達業者'
	when 3 then N'已送達業者'
	when 4 then N'已送達手機'
	when 5 then N'內容或資料有錯誤'
	when 6 then N'門號有錯誤'
	when 7 then N'簡訊或門號已停用'
	when 8 then N'逾時無送達'
	when 9 then N'預約已取消'
	else '' end as OriginalStatus
	,COUNT(*) AS Amount
	,MAX(T1.[CreatedOn]) AS CreatedOn
	FROM 
	(
		SELECT T2.[VoucherId]
			, T1.[OriginalStatus]
			, T1.[CreatedTime] AS [CreatedOn]
			, ROW_NUMBER() OVER (PARTITION BY T2.[VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
		FROM [dbo].[DistributionSLMSMessageStatus] AS T1 with(NOLOCK)
			JOIN [dbo].[DistributionTaskMessageVoucher] AS T2 with(NOLOCK) ON T1.[DistributionTaskMessageId] = T2.[DistributionTaskMessageId]
			) AS T1
	JOIN [dbo].[Voucher] AS T2 with(NOLOCK) ON T1.VoucherId = T2.Id
	JOIN [dbo].[OrderBeneficiaryInfo] AS T3 with(NOLOCK) ON T2.[BeneficiaryInfoId] = T3.Id
	JOIN [dbo].[OrderLine] AS T4 with(NOLOCK) ON T3.OrderLineId = T4.Id
	JOIN [dbo].[Order] AS T5 with(NOLOCK) ON T4.OrderId = T5.Id
	WHERE  T1.NewIndex = 1
	AND T5.OrderNumber = @OrderNumber
	GROUP BY [OriginalStatus]


	SELECT T3.[Mobile]
	,	case [OriginalStatus] when 0 then N'預約傳送中'
	when 1 then N'已送達業者'
	when 2 then N'已送達業者'
	when 3 then N'已送達業者'
	when 4 then N'已送達手機'
	when 5 then N'內容或資料有錯誤'
	when 6 then N'門號有錯誤'
	when 7 then N'簡訊或門號已停用'
	when 8 then N'逾時無送達'
	when 9 then N'預約已取消'
	else '' end as OriginalStatus
	,T1.[CreatedOn]
	FROM 
	(
		SELECT T2.[VoucherId]
			, T1.[OriginalStatus]
			, T1.[CreatedTime]AS [CreatedOn]
			, ROW_NUMBER() OVER (PARTITION BY T2.[VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
		FROM [dbo].[DistributionSLMSMessageStatus] AS T1 with(NOLOCK)
			JOIN [dbo].[DistributionTaskMessageVoucher] AS T2 with(NOLOCK) ON T1.[DistributionTaskMessageId] = T2.[DistributionTaskMessageId]
			) AS T1
	JOIN [dbo].[Voucher] AS T2 with(NOLOCK) ON T1.VoucherId = T2.Id
	JOIN [dbo].[OrderBeneficiaryInfo] AS T3 with(NOLOCK) ON T2.[BeneficiaryInfoId] = T3.Id
	JOIN [dbo].[OrderLine] AS T4 with(NOLOCK) ON T3.OrderLineId = T4.Id
	JOIN [dbo].[Order] AS T5 with(NOLOCK) ON T4.OrderId = T5.Id
	WHERE  T1.NewIndex = 1
	AND T5.OrderNumber = @OrderNumber
END
