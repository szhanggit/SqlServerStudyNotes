CREATE PROCEDURE spGetShopEntityInfo
	@IdentityCode VARCHAR(50), 
	@ProgramId INT,
	@MerchantCode VARCHAR(50) = NULL 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select 
		top 1 s.SecurityKeyId,s.TimeOffset,s.MaxFailNumber 
	from Shop s with(nolock)
	left join Merchant m on s.MerchantId = m.Id
    where s.Status = 1 and s.ProgramId = @ProgramId 
		and s.IdentityCode = @IdentityCode
		and (@MerchantCode is null OR m.IdentityCode = @MerchantCode) 
END