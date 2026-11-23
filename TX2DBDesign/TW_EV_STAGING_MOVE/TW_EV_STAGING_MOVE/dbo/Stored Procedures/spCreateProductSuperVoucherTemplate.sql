-- =============================================
-- Author:		Knight YAO
-- Create date: 2015/09/06
-- Description:	Assign voucher.
-- =============================================
CREATE PROCEDURE [dbo].[spCreateProductSuperVoucherTemplate]
	@ProductVersionId		int,
	@DescriptionContent		nvarchar(max),
	@CreatedBy				nvarchar(50)
AS
BEGIN

	declare @currentVersionNumber int
	set @currentVersionNumber = 0

	select 
		@currentVersionNumber = [Version] 
	from ProductSuperVoucherTemplate with(nolock)
	where ProductVersionId = @ProductVersionId

	insert into ProductSuperVoucherTemplate (ProductVersionId, DescriptionContent, [Version], VersionTime, CreatedBy)
	select @ProductVersionId, @DescriptionContent, @currentVersionNumber + 1, GETDATE(), @CreatedBy

END