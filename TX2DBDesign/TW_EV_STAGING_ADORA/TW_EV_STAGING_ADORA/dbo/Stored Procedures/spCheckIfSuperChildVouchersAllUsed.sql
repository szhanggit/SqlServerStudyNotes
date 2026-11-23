-- =============================================
-- Author:		<Zhang, Steven>
-- Create date: <2022-04-12>
-- Description:	<https://dev.azure.com/edenred-apac-product/TX2/_workitems/edit/3469>
-- =============================================

CREATE PROCEDURE [dbo].[spCheckIfSuperChildVouchersAllUsed]
	@ChildAccountNumber varchar(50)
	, @ChildProgramIdentityCode varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	--Return 1 => ChildAllused is true
	--Return 0 => ChildAllused is false
	Declare @MasterAccountNumber varchar(50);
	Declare @MasterProgramId int;
	Declare @MasterProgramIdentityCode varchar(50);
	Declare @MasterExternalProgramId int;
	Declare @MasterAccountStatus int;
	Declare @MasterAdoraProductId int;
	Declare @ChildProgramId int;
	
	select @ChildProgramId = Id from Program with(nolock) where IdentityCode = @ChildProgramIdentityCode		

	select @MasterAccountNumber = MasterAccountNumber, @MasterProgramIdentityCode = MasterProgramIdentityCode from Account with(nolock) where AccountNumber = @ChildAccountNumber AND ProgramId = @ChildProgramId
	if @MasterAccountNumber is null
	begin
		select @MasterAccountNumber = MasterAccountNumber, @MasterProgramIdentityCode = MasterProgramIdentityCode from AccountHistory with(nolock) where AccountNumber = @ChildAccountNumber AND ProgramId = @ChildProgramId
	end
	
	if @MasterAccountNumber is not null
	begin
		select @MasterExternalProgramId = mp.Id, @MasterProgramId = ap.Id from Program ap with(nolock)
		inner join TW_EV_UAT_MOVE.dbo.Program mp with(nolock) on ap.ExternalId = mp.Id
		where ap.IdentityCode = @MasterProgramIdentityCode	
	
		select @MasterAdoraProductId = ProductId, @MasterAccountStatus = [Status] from Account with(nolock) where AccountNumber = @MasterAccountNumber AND ProgramId = @MasterProgramId
		if @MasterAdoraProductId is null
		begin
			select @MasterAdoraProductId = ProductId, @MasterAccountStatus = [Status] from AccountHistory with(nolock) where AccountNumber = @MasterAccountNumber AND ProgramId = @MasterProgramId
		end

		if (exists(
			select 1 from TW_EV_UAT_MOVE.dbo.VoucherCombo vc with(nolock) 
			inner join TW_EV_UAT_MOVE.dbo.Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id
			inner join TW_EV_UAT_MOVE.dbo.Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id
			inner join TW_EV_UAT_MOVE.dbo.Program mp with(nolock) on cv.ProgramId = mp.Id
			where cv.VoucherNumber = @ChildAccountNumber AND mp.IdentityCode = @ChildProgramIdentityCode AND vc.[Status] = 1) AND (@MasterAccountStatus = 32))
		begin	--It is super voucher and master vocuher has been fully redeemed.
			if exists(select 1 from TW_EV_UAT_MOVE.dbo.VoucherCombo vc with(nolock) 
			inner join TW_EV_UAT_MOVE.dbo.Voucher mv with(nolock) on vc.MasterVoucherId = mv.Id
			inner join TW_EV_UAT_MOVE.dbo.Voucher cv with(nolock) on vc.ChildVoucherId = cv.Id
			inner join Program ap with(nolock) on cv.ProgramId = ap.ExternalId
			inner join Account childA with(nolock) on cv.VoucherNumber = childA.AccountNumber AND childA.ProgramId = ap.Id
			where mv.VoucherNumber = @MasterAccountNumber AND mv.ProgramId = @MasterExternalProgramId AND vc.[Status] = 1 AND childA.[Status] = 2)
			begin	--There are still some available vocuhers.
				select 0;
			end
			else
			begin	--There are no available child vouchers at all.
				select 1;
			end
		end
		else
		begin	--Voucher type is not qualified.
			select 0;
		end
	end
	else
	begin
		select 0;
	end
END
