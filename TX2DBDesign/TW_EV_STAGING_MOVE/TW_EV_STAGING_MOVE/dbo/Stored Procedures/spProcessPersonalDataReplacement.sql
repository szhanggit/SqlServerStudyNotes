CREATE PROCEDURE [dbo].[spProcessPersonalDataReplacement]
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @Email VARCHAR(100)
	DECLARE @Mobile VARCHAR(50)
	DECLARE @Name NVARCHAR(100)
	DECLARE @Address NVARCHAR(200)
	DECLARE @PostCode VARCHAR(20)

	select @Email = CONVERT(varchar(10) , getdate(), 112 )+'@auditor.remove'
	select @Mobile = '99'+CONVERT(varchar(10) , getdate(), 112 )
	select @Name = CONVERT(nvarchar(10) , getdate(), 112 )+'auditorremove'
	select @Address = CONVERT(nvarchar(10) , getdate(), 112 )+'auditorremove'
	select @PostCode = CONVERT(nvarchar(10) , getdate(), 112 )+'auditor'

	update obi set Email = @Email,Mobile = @Mobile, [Name]=@Name,[Address] = @Address,PostCode = @PostCode
	from OrderBeneficiaryInfo obi
	join OrderBeneficiaryInfoArchiveBuffer obiaf with(nolock) on obi.Id = obiaf.Id

	insert into OrderBeneficiaryInfoArchive select Id from OrderBeneficiaryInfoArchiveBuffer with(nolock)
	delete OrderBeneficiaryInfoArchiveBuffer
END
