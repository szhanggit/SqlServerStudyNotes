
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE spGetDistributionFailVoucher 
	@StartDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--TO TEST
	--DECLARE @StartDate DATETIME
	--SET @StartDate = '2018-06-06 11:12:35.000'
	--TO TEST END

    -- Insert statements for procedure here
	SELECT [VoucherNumber]
		,CASE WHEN [DistributionEmailStatus] = 4 THEN 'SendFail' ELSE '' END AS EmailFail
		,CASE WHEN [DistributionSLMSStatus] = 4  THEN 'SendFail' ELSE '' END AS SLMSFail
	FROM Voucher WITH(NOLOCK)
	WHERE ([DistributionEmailStatus] = 4 OR [DistributionSLMSStatus] = 4)
	AND [PublishedOn] >= @StartDate

END
