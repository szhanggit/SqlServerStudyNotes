
-- =============================================
-- Author:		Zhu Jianhua
-- Create date: 2016-07-20
-- Description:	Get voucher guid by voucher alias and auth vode.
-- =============================================
CREATE PROCEDURE  [dbo].[spGetVoucherGuidByShortUrl] 
	@voucherAlias varchar(50),
	@authCode varchar(20),
	@voucherId bigint out
AS
BEGIN

	SET NOCOUNT ON;

	SET @voucherId = 0;

	SELECT @voucherId = [id]
	FROM [dbo].[Voucher] with(nolock)
	WHERE ShortUrl = @voucherAlias
		AND [AuthCode] = @authCode

END
