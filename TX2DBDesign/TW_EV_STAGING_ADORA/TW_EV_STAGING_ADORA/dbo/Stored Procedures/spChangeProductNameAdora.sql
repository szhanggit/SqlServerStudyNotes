-- =============================================
-- Author:		Steven Zhang
-- Create date: 2019/08/28
-- Description:	Change Product Name.
-- =============================================
CREATE PROCEDURE [dbo].[spChangeProductNameAdora]
	@ProductCode			varchar(50)
	,@ProductName			nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ProductExternalId int;
	DECLARE @ProductId INT;
	SELECT @ProductExternalId = Id FROM TW_EV_DBS_MOVE.dbo.Product WITH(nolock) WHERE ProductCode = @ProductCode;
	SELECT @ProductId = Id FROM Product WITH(nolock) WHERE ExternalId = @ProductExternalId;
	
	BEGIN TRAN
	BEGIN TRY

	IF @ProductId IS not NULL AND @ProductId != ''
	BEGIN
		UPDATE dbo.Product
		SET [Name] = @ProductName, DisplayName = @ProductName
		WHERE Id = @ProductId
	END

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
