
CREATE PROC InsertVoucherTrustAccountFromBuffer @step INT
AS
BEGIN
    SET NOCOUNT ON;

	--OrderLineTrustAccount同一个OrderLine会有多条记录，需要取Voucher对应的记录
	--API Order : ValidTo = 3999.12.31
	--ExpiryPolicyId：1. Voucher.ActivatedOn + 1 year 2.same as Voucher.ExpiryDate 3.same as OrderLineTrustAccount.ValidTo
	--if None Api and ExpiryPolicyId = 1, use OrderLineTrustAccount.ValidTo or Voucher.PublishedOn + 1 year
	--if Voucher.status = 2 or 32, and ActivatedOn has value, 我就认为ExpiryDate有值

	DECLARE @rowCount int = 0;
	DECLARE @sessionId VARCHAR(50) = CONVERT(VARCHAR(50),NEWID());
	DECLARE @maxDate DATE = DATEFROMPARTS(2999, 12, 31);

	UPDATE TOP(@step) buf SET buf.SessionId = @sessionId
		FROM dbo.VoucherTrustAccountBuffer buf
		JOIN dbo.Voucher v WITH(NOLOCK) ON buf.VoucherId = v.Id
		JOIN dbo.OrderLineTrustAccount ot WITH(NOLOCK) ON buf.OrderLineTrustAccountId = ot.Id
		WHERE (v.[Status] = 2 AND v.ActivatedOn IS NOT NULL)
			OR (v.[Status] = 8	AND v.ActivatedOn IS NOT NULL)
			OR (v.[Status] = 16	AND v.ActivatedOn IS NOT NULL)
			OR (v.[Status] = 32	AND v.ActivatedOn IS NOT NULL)	
			OR (v.[Status] = 64 AND v.BeneficiaryInfoId IS NOT NULL AND ot.ExpiryPolicyId <> 2);
	SET @rowCount = @@ROWCOUNT;
	IF @rowCount = 0
	BEGIN
		SELECT @rowCount;
		RETURN 0;
	END
	
	BEGIN TRY
	BEGIN TRAN
		INSERT dbo.VoucherTrustAccount
		(
			Id,
		    TrustAccountId,
		    TrustAmountOption,
		    TrustAccountBatchNo,
		    Amount,
		    ExpiryPolicyId,
		    ExpiryDate
		)
		SELECT
			buf.VoucherId,
		    ot.TrustAccountId,		-- TrustAccountId - int
		    ot.TrustAccountOption,	-- TrustAmountOption - int
		    ot.TrustAccountBatchNo,	-- TrustAccountBatchNo - nvarchar(200)
		    ot.Amount,				-- Amount - numeric(20, 6)
		    ot.ExpiryPolicyId,		-- ExpiryPolicyId - int
		    IIF(ot.ExpiryPolicyId = 2, 
				DATEADD(SECOND,-1,DATEADD(DAY,1,CONVERT(DATETIME,CONVERT(DATE,v.ExpiryDate)))), 
				IIF(ot.ValidTo > @maxDate, DATEADD(SECOND,-1,DATEADD(DAY,1,CONVERT(DATETIME,CONVERT(DATE,DATEADD(YEAR, 1, v.ActivatedOn))))), ot.ValidTo)
				)
		FROM dbo.VoucherTrustAccountBuffer buf 
			JOIN dbo.OrderLineTrustAccount ot WITH(NOLOCK) ON buf.OrderLineTrustAccountId = ot.Id
			JOIN dbo.Voucher v WITH(NOLOCK) ON buf.VoucherId = v.Id
		WHERE buf.SessionId = @sessionId

		DELETE dbo.VoucherTrustAccountBuffer WHERE SessionId = @sessionId

		SET @rowCount = @@ROWCOUNT;
		SELECT @rowCount;
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		SELECT @rowCount;
	END CATCH
END;
