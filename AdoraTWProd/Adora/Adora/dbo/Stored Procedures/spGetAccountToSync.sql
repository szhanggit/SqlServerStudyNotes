-- =============================================
-- Author:		Knight Yao
-- Create date: 2016/06/29
-- Description:	Get Account To Sync
-- =============================================
CREATE PROCEDURE spGetAccountToSync
	@StartChangedUTCTimeL BIGINT
	,@EndChangedUTCTimeL   BIGINT
	,@ProgramCode VARCHAR(20)
	,@Count INT
	,@Status INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProgramId INT
	SELECT @ProgramId = Id FROM Program WHERE IdentityCode = @ProgramCode

	DECLARE @RealEndChangedUTCTimeL AS BIGINT

	SELECT @RealEndChangedUTCTimeL = MAX(LastChangedUTCTimeL)
	FROM(
		SELECT TOP (@Count) AccountNumber,MAX([ChangedUTCTimeL]) LastChangedUTCTimeL
		FROM AccountToSync WITH(NOLOCK)
		WHERE programid = @ProgramId 
			AND [ChangedUTCTimeL] > @StartChangedUTCTimeL 
			AND [ChangedUTCTimeL]<= @EndChangedUTCTimeL
			AND ((@Status IS NULL AND 1=1) OR (@Status IS NOT NULL AND ([Status] = @Status)))
		GROUP BY AccountNumber
		ORDER BY LastChangedUTCTimeL
	) temp

	SELECT a.[AccountNumber]
		  ,a.[ProgramId]
		  ,a.[BalanceAvailable]
		  ,a.[BalanceFrozen]
		  ,a.[Status]
		  ,a.[CreatedOn]
		  ,a.[ActiveTo]
		  ,a.[ActivatedOn]
		  ,a.[ConsumeTime]
		  ,a.[ConsumeMerchantCode]
		  ,a.[ConsumeShopCode]
		  ,a.[ChangedUTCTimeL]
		  ,a.[ConsumeTerminalSSN]
		  ,a.[LastTranOn]
    FROM AccountToSync a WITH(NOLOCK)
	    JOIN (SELECT AccountNumber
				,MAX(ChangedTimestamp) AS ChangedTimestamp 
               FROM AccountToSync 
               WHERE programid = @ProgramId 
				   AND [ChangedUTCTimeL] > @StartChangedUTCTimeL 
				   AND [ChangedUTCTimeL]<= @RealEndChangedUTCTimeL
				   AND ((@Status IS NULL AND 1=1) OR (@Status IS NOT NULL AND ([Status] = @Status)))
               GROUP BY AccountNumber) at 
		ON a.AccountNumber = at.AccountNumber 
			AND a.ChangedTimestamp =  at.ChangedTimestamp 
			AND a.ProgramId = @ProgramId

END
