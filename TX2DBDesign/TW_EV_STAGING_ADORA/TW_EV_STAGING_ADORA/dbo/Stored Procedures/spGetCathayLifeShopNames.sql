
CREATE PROCEDURE [dbo].[spGetCathayLifeShopNames]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT MerchantCode from dbo.EXT_TW_CathayLifeShopName with(nolock)

END

