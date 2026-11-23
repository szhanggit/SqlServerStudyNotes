create PROCEDURE [dbo].[spGetVoucherByGUID2]
	@GUID		varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select * from Voucher with(nolock)
	where [GUID] = @GUID
END	
