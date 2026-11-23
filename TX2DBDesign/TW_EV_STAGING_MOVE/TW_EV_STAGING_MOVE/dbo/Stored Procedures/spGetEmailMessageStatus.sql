-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetEmailMessageStatus 
	-- Add the parameters for the stored procedure here
	@OrderNumber VARCHAR(50),
	@ShowDetail BIT = 1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select T2.[VoucherId],T1.[OriginalStatus],T1.OriginalTime,T1.CreatedTime,T3.Email
	into #GetEmailMessageStatusTemp
	from [dbo].[Order] AS T5 with(NOLOCK)
		join [dbo].[OrderLine] AS T4 with(NOLOCK) ON T4.OrderId = T5.Id
		JOIN [dbo].[OrderBeneficiaryInfo] AS T3 with(NOLOCK,forceseek) ON T3.OrderLineId = T4.Id
		JOIN [dbo].[Voucher] AS T with(NOLOCK,forceseek) ON T.[BeneficiaryInfoId] = T3.Id
		JOIN [dbo].[DistributionTaskMessageVoucher] AS T2 with(NOLOCK,forceseek) ON T2.VoucherId = T.Id
		JOIN [dbo].[DistributionEmailMessageStatus] AS T1 with(NOLOCK,forceseek) ON T1.[DistributionTaskMessageId] = T2.[DistributionTaskMessageId]
			where T5.OrderNumber = @OrderNumber

    -- Insert statements for procedure here
	SELECT
	[OriginalStatus] AS DeliveryStatus
	,COUNT(*) AS Amount
	FROM 
	(
		SELECT T1.[VoucherId]
			, [OriginalStatus]
			, ROW_NUMBER() OVER (PARTITION BY [VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
		FROM #GetEmailMessageStatusTemp AS T1		
		) AS T1
	WHERE  T1.NewIndex = 1
	GROUP BY [OriginalStatus]

	IF(@ShowDetail = 1)
	BEGIN
		SELECT
		T1.[Email]
		,[OriginalStatus] AS DeliveryStatus
		, case [OriginalStatus] when 'Processing' then null
          else T1.[CreatedOn] end AS [TIME]
		FROM 
		(
			SELECT T1.[VoucherId]
				, [OriginalStatus]
				, [OriginalTime] AS [CreatedOn]
				, Email
				, ROW_NUMBER() OVER (PARTITION BY [VoucherId] ORDER BY T1.OriginalTime DESC,T1.CreatedTime DESC) NewIndex
			FROM #GetEmailMessageStatusTemp AS T1
			) AS T1
		WHERE  T1.NewIndex = 1
	END
Drop table #GetEmailMessageStatusTemp

END
