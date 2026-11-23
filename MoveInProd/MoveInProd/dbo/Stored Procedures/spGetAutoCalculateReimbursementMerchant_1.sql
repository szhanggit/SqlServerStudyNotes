
CREATE PROCEDURE [dbo].[spGetAutoCalculateReimbursementMerchant] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @CurrentDate char(10)
	DECLARE @CurrentMonthLastDate char(10)

	SET @CurrentDate = CONVERT(char(10),GETDATE(),120)
	SET @CurrentMonthLastDate = CONVERT(CHAR(10),EOMONTH(GETDATE(),0),120)

	SELECT Id 
	FROM Merchant
	WHERE [Status] = 1
	AND IsAutoCreateReimbursement = 1
	AND (([AutoCreateReimbursementIntervalType] = 0 AND [AutoCreateReimbursementDay] != 0 AND [AutoCreateReimbursementDay] = DAY(GETDATE()))
		 OR	([AutoCreateReimbursementIntervalType] = 0 AND [AutoCreateReimbursementDay] = 0 AND @CurrentDate = @CurrentMonthLastDate)
		 OR ([AutoCreateReimbursementIntervalType] = 1))


END

