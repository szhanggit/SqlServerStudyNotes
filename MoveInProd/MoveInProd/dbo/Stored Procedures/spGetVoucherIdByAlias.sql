
-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2017-06-16
-- Description:	Get voucher guid by voucher alias and auth vode.
-- =============================================
CREATE PROCEDURE  [dbo].[spGetVoucherIdByAlias] 
	@voucherAlias varchar(50),
	@voucherId bigint out
AS
BEGIN

	SET NOCOUNT ON;

	SET @voucherId = 0;

	SELECT @voucherId = [id]
	FROM [dbo].[Voucher] with(nolock)
	WHERE [ShortUrl] = @voucherAlias

END

