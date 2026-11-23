-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spGetVoucherPublishOn]
	-- Add the parameters for the stored procedure here
	@VoucherNumber  VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CONVERT(VARCHAR(100), [PublishedOn], 120) AS [PublishedOn]
	FROM [dbo].[Voucher]
	WHERE [VoucherNumber] = @VoucherNumber

END

