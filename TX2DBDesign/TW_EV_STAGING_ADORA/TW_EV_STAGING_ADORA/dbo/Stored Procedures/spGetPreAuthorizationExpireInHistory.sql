
CREATE PROCEDURE dbo.spGetPreAuthorizationExpireInHistory
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DateTimeL BIGINT = CONVERT(BIGINT, FORMAT(DATEADD(HOUR, -48, GETUTCDATE()), 'yyyyMMddHHmmss'));
	SELECT 
		th.AccountNumber,
		th.BalanceAvailable TranBalanceAvailable,
		th.BalanceFrozen TranBalanceFrozen,
		th.TranCode,
		th.TranCodeRef,
		th.RefundedAmount,
		th.TranType,
		th.TranAmount,
		th.[Status] TranStatus,
		th.ResponseCode,
		th.[Checksum] TranChecksum,
		th.TranUtcDateTime,
		a.ValueType,
		a.[Status] AccountStatus,
		a.BalanceAvailable,
		a.BalanceFrozen,
		a.[Checksum] AccountChecksum,
		a.ModifyVersion AccountModifyVersion,
		pg.Id ProgramId,
		pg.IdentityCode ProgramCode,
		pg.TimeOffset,
		r.Id RestrictionId,
		r.PreAuthorizationExpiryUnit,
		r.PreAuthorizationExpiryInterval,
		k.[Value] SecurityValue
	FROM dbo.TransactionHistory th WITH(NOLOCK)
	JOIN dbo.Program pg WITH(NOLOCK) ON pg.IdentityCode = th.ProgramCode
	JOIN dbo.Account a WITH(NOLOCK) ON a.AccountNumber = th.AccountNumber AND a.ProgramId = pg.Id
	JOIN dbo.SecurityKey k WITH(NOLOCK) ON k.Id = th.SecurityKeyId
	JOIN dbo.Restriction r WITH(NOLOCK) ON r.Id = a.RestrictionId AND r.ProgramId = pg.Id
	WHERE th.TranUtcDateTimeL > @DateTimeL AND th.TranType = 102 AND th.[Status] = 1 AND th.ResponseCode = '0000'
END;
