CREATE PROCEDURE dbo.spCheckSendVoucherFail
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @table TABLE(
		VoucherNumber VARCHAR(50) NOT NULL
	)
	
	INSERT @table
	(
	    VoucherNumber
	)
	SELECT VoucherNumber FROM dbo.SendVoucherRetryInfo WITH(NOLOCK) 
		WHERE (CreatedTime < DATEADD(MINUTE, -30, GETDATE()) AND CreatedTime > DATEADD(MINUTE, -60, GETDATE())) 
		AND ResponseCode = '9999' AND TryCount > 0
		ORDER BY Id DESC;
	
	DECLARE @message VARCHAR(100);
	IF EXISTS (SELECT 1 FROM @table)
	BEGIN
		DECLARE @dbprefix VARCHAR(2) = (Select LEFT(name, 2) From sys.SysDataBases Where DbId=(Select Dbid From sys.SysProcesses Where Spid = @@spid))
		SET @message = @dbprefix + ' PROD Voucher ' + (SELECT TOP (3) VoucherNumber + ',' FROM @table for xml path('')) + ' CheckSendVoucherFail';
	END
	SELECT N'CheckSendVoucherFail' AS [Name], COUNT(1) AS Result, @message [Message] FROM @table;
END