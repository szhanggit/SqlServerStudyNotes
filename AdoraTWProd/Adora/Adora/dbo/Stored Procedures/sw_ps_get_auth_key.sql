-- =============================================
-- Author:		Yun Lian
-- Create date: 2015-02-09
-- Description:	get work key for merchant or shop
-- =============================================
CREATE PROCEDURE [dbo].[sw_ps_get_auth_key]
	@ProgramCode varchar(20),
	@MerchantCode varchar(50),
	@ShopCode varchar(50) = null,
	@UtcTime datetime,
	@WorkKey varchar(48) = '' output,
	@SecurityKey varchar(48) = '' output
AS
BEGIN
	
	declare @ProgramID int
	declare @offset varchar(6)
	-- if shopcode is null or empty
	if (@ShopCode is null or @ShopCode = '')
		begin
			-- get programID
			select @ProgramID = id from [dbo].[Program]
			where [IdentityCode] = @ProgramCode

			--get timeoffset
			select @offset = [TimeOffset] from [dbo].[Merchant] m
			where m.ProgramId = @ProgramID and m.IdentityCode = @MerchantCode

			select @WorkKey = isnull(w.value,'')
			from [dbo].[Merchant] m left join [dbo].[WorkKey] w
			on m.[WorkKeyId] = w.[Id]
			where m.ProgramId = @ProgramID and m.IdentityCode = @MerchantCode
			and dbo.fnCalcLocalDate(@UtcTime,@offset) = dbo.fnCalcLocalDate(w.CreatedOn,@offset)

			select @SecurityKey = isnull(s.value,'')
			from [dbo].[Merchant] m left join [dbo].[SecurityKey] s
			on m.[SecurityKeyId] = s.[Id]
			where m.ProgramId = @ProgramID and m.IdentityCode = @MerchantCode
		end
	else
		begin
			-- get programID
			select @ProgramID = id from [dbo].[Program]
			where [IdentityCode] = @ProgramCode

			-- get offset
			select @offset = [TimeOffset] from [dbo].[Shop] s
			where s.ProgramId = @ProgramID and s.IdentityCode = @ShopCode

			select @WorkKey = isnull(w.value,'')
			from [dbo].[Shop] s left join [dbo].[WorkKey] w
			on s.[WorkKeyId] = w.id
			where s.ProgramId = @ProgramID and s.IdentityCode = @ShopCode
			and dbo.fnCalcLocalDate(@UtcTime,@offset) = dbo.fnCalcLocalDate(w.CreatedOn,@offset)

			select @SecurityKey = isnull(se.value,'')
			from [dbo].[Shop] s left join [dbo].[SecurityKey] se
			on s.[SecurityKeyId] = se.id
			where s.ProgramId = @ProgramID and s.IdentityCode = @ShopCode
		end

END
