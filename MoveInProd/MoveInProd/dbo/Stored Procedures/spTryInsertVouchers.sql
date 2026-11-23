
CREATE PROCEDURE [dbo].[spTryInsertVouchers] @Count INT
	,@UserName NVARCHAR(50)
	,@ProductId INT
	,@BalanceAvailable INT
	,@ReservationBatchId BIGINT
	,@CacheNode TINYINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @remaining INT

	DELETE t1
	FROM VoucherTemp t1
	JOIN VoucherTemp t2 ON t1.VoucherNumber = t2.VoucherNumber
		AND t1.ProgramId = t2.ProgramId
	WHERE t1.UserName = @UserName
		AND t2.UserName <> @UserName

	DELETE t
	FROM VoucherTemp t
	INNER JOIN Voucher v ON v.ProgramId = t.ProgramId
		AND v.VoucherNumber = t.VoucherNumber
	WHERE t.UserName = @UserName

	SELECT @remaining = COUNT(1)
	FROM VoucherTemp
	WHERE UserName = @UserName

	IF @remaining >= @Count
	BEGIN
		BEGIN TRAN

		INSERT INTO Voucher (
			ProgramId
			,VoucherNumber
			,ProductId
			,STATUS
			,BalanceAvailable
			,GUID
			,ReservationBatchId
			,CacheNode
			)
		SELECT TOP (@Count) ProgramId
			,VoucherNumber
			,@ProductId
			,IIF(@CacheNode IS NOT NULL, 128, 64) 
			,@BalanceAvailable
			,NEWID()
			,@ReservationBatchId
			,@CacheNode
		FROM VoucherTemp
		WHERE UserName = @UserName

		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRAN

			RETURN - 1
		END
		ELSE
		BEGIN
			COMMIT TRAN

			DELETE FROM VoucherTemp
			WHERE UserName = @UserName

			RETURN 0
		END
	END
	ELSE
		RETURN @Count - @remaining
END


