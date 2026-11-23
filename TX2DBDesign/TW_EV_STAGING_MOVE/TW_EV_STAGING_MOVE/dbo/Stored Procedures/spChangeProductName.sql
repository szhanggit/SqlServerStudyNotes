-- =============================================
-- Author:		Steven Zhang
-- Create date: 2019/07/30
-- Description:	Change Product Name.
-- =============================================
CREATE PROCEDURE [dbo].[spChangeProductName]
	@ProductCode			varchar(50)
	,@ProductName			nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY

	update Product
	set ProductName = @ProductName
	where ProductCode = @ProductCode;


	update ProductVersion
	set ProductName = @ProductName
	where ProductId in (select Id from Product where ProductCode = @ProductCode)

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
