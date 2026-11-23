-- =============================================
-- Author:		Yun Lian
-- Create date: 2015-05-12
-- Description:	check if merchant uid exist
-- =============================================
CREATE PROCEDURE [dbo].[sw_pf_check_merchant_code] 
	@merchantCode varchar(50)
AS
BEGIN
	select [IdentityCode] from [dbo].[Merchant]
	where [IdentityCode] = @merchantCode
END
