-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetSLMSMessageStatus 
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50),
	@ShowDetail BIT = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select T2.[VoucherId],T1.[OriginalStatus],T1.OriginalTime,T1.CreatedTime 
	into #GetSLMSMessageStatusTemp
	from [dbo].[Order] AS T5 with(NOLOCK)
		join [dbo].[OrderLine] AS T4 with(NOLOCK) ON T4.OrderId = T5.Id
		JOIN [dbo].[OrderBeneficiaryInfo] AS T3 with(NOLOCK,forceseek) ON T3.OrderLineId = T4.Id
		JOIN [dbo].[Voucher] AS T with(NOLOCK,forceseek) ON T.[BeneficiaryInfoId] = T3.Id
		JOIN [dbo].[DistributionTaskMessageVoucher] AS T2 with(NOLOCK,forceseek) ON T2.VoucherId = T.Id
		JOIN [dbo].[DistributionSLMSMessageStatus] AS T1 with(NOLOCK,forceseek) ON T1.[DistributionTaskMessageId] = T2.[DistributionTaskMessageId]
			where T5.OrderNumber = @OrderNumber

    -- Insert statements for procedure here
	SELECT
	case [OriginalStatus] when N'0' then N'預約傳送中'
	when N'1' then N'已送達業者'
	when N'2' then N'已送達業者'
	when N'3' then N'已送達業者'
	when N'4' then N'已送達手機'
	when N'5' then N'內容或資料有錯誤'
	when N'6' then N'門號有錯誤'
	when N'7' then N'簡訊或門號已停用'
	when N'8' then N'逾時無送達'
	when N'9' then N'預約已取消'
	when N'99' then N'Processing'
	when N'預約傳送中' then N'預約傳送中'
	when N'已送達業者' then N'已送達業者'
	when N'已送達手機' then N'已送達手機'
	when N'內容或資料有錯誤' then N'內容或資料有錯誤'
	when N'門號有錯誤' then N'門號有錯誤'
	when N'簡訊或門號已停用' then N'簡訊或門號已停用'
	when N'逾時無送達' then N'逾時無送達'
	when N'預約已取消' then N'預約已取消'
	else N'' end AS DeliveryStatus
	,COUNT(*) AS Amount
	FROM 
	(
		SELECT T1.[VoucherId]
			, T1.[OriginalStatus]
			, ROW_NUMBER() OVER (PARTITION BY T1.[VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
		FROM #GetSLMSMessageStatusTemp AS T1
			) AS T1
	WHERE  T1.NewIndex = 1
	GROUP BY [OriginalStatus]

	IF(@ShowDetail = 1)
	BEGIN
		SELECT T3.[Mobile]
		,	case [OriginalStatus] when N'0' then N'預約傳送中'
		when N'1' then N'已送達業者'
		when N'2' then N'已送達業者'
		when N'3' then N'已送達業者'
		when N'4' then N'已送達手機'
		when N'5' then N'內容或資料有錯誤'
		when N'6' then N'門號有錯誤'
		when N'7' then N'簡訊或門號已停用'
		when N'8' then N'逾時無送達'
		when N'9' then N'預約已取消'
		when N'99' then N'Processing'
		when N'預約傳送中' then N'預約傳送中'
		when N'已送達業者' then N'已送達業者'
		when N'已送達手機' then N'已送達手機'
		when N'內容或資料有錯誤' then N'內容或資料有錯誤'
		when N'門號有錯誤' then N'門號有錯誤'
		when N'簡訊或門號已停用' then N'簡訊或門號已停用'
		when N'逾時無送達' then N'逾時無送達'
		when N'預約已取消' then N'預約已取消'
		else N'' end AS DeliveryStatus
		, case [OriginalStatus] when N'99' then null
          else T1.[CreatedOn] end AS [TIME]
		FROM 
		(
			SELECT T1.[VoucherId]
				, T1.[OriginalStatus]
				, T1.[OriginalTime]AS [CreatedOn]
				, ROW_NUMBER() OVER (PARTITION BY T1.[VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
			FROM #GetSLMSMessageStatusTemp AS T1
				) AS T1
		JOIN [dbo].[Voucher] AS T2 with(NOLOCK) ON T1.VoucherId = T2.Id
		JOIN [dbo].[OrderBeneficiaryInfo] AS T3 with(NOLOCK) ON T2.[BeneficiaryInfoId] = T3.Id
		JOIN [dbo].[OrderLine] AS T4 with(NOLOCK) ON T3.OrderLineId = T4.Id
		JOIN [dbo].[Order] AS T5 with(NOLOCK) ON T4.OrderId = T5.Id
		WHERE  T1.NewIndex = 1
		AND T5.OrderNumber = @OrderNumber
	END
drop table #GetSLMSMessageStatusTemp

END