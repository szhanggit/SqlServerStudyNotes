CREATE PROCEDURE [dbo].[spGetVoucherFromRepository] @Count INT
	,@ProgramId INT
	,@VoucherPrefix VARCHAR(15)
	,@VoucherLength INT
	,@CheckSumLength INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP (@Count) t.VoucherNumber
	FROM (
		SELECT VoucherNumber
		FROM VoucherRepository
		WHERE VoucherNumberLength = @VoucherLength

		EXCEPT

		SELECT vr.VoucherNumber
		FROM VoucherRepository vr
		INNER JOIN Voucher v ON vr.VoucherNumber = LEFT(RIGHT(v.VoucherNumber, LEN(v.VoucherNumber) - LEN(@VoucherPrefix)), @VoucherLength)
			AND LEN(v.VoucherNumber) = LEN(@VoucherPrefix) + @VoucherLength + @CheckSumLength
		WHERE v.ProgramId = @ProgramId
			AND LEFT(v.VoucherNumber, LEN(@VoucherPrefix)) = @VoucherPrefix
			AND vr.VoucherNumberLength = @VoucherLength
		) t
	ORDER BY NEWID()
END
