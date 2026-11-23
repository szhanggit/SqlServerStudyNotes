
CREATE PROCEDURE dbo.spGetUnSyncVoucherNumByProgram
@ProgramId INT,
@VoucherNumber INT OUTPUT
AS
    SET NOCOUNT ON
	if exists (	SELECT * FROM dbo.AccountToSync ats WITH(NOLOCK)  
	INNER JOIN Program p WITH(NOLOCK) ON ats.ProgramId = p.Id
	WHERE p.ExternalId = @ProgramId)
	begin
		SELECT @VoucherNumber = count(*) FROM dbo.AccountToSync ats WITH(NOLOCK)  
		INNER JOIN Program p WITH(NOLOCK) ON ats.ProgramId = p.Id
		WHERE p.ExternalId = @ProgramId;
	end
	else
	begin
		set @VoucherNumber = 0;
	end
