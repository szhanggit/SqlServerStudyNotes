
CREATE PROCEDURE [dbo].[spCleanVoucherTemp] @UserName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	FROM VoucherTemp
	WHERE UserName = @UserName
END

