
CREATE PROCEDURE [dbo].[spGetGRVoucherInfoId]
	@Ecode NVARCHAR(500) = NULL
AS
BEGIN
	select Id from Voucher where ExtendId in(SELECT Id FROM EXT_GR_VoucherInfo WHERE (@Ecode IS NULL OR Ecode = @Ecode))
END
