-- =============================================
-- Author:		Steven Yu
-- Create date: 2014/08/07
-- Description:	Archive batch log.
-- =============================================
CREATE PROCEDURE spArchiveBatchLog
	@ArchiveDate			DATETIME
	,@ErrorMessage			nvarchar(4000)	OUTPUT
	,@ErrorLine				int				OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

	BEGIN TRY
		INSERT INTO [dbo].[BatchLogHistory]
           ([Id],[ProgramId],[BatchName],[ExecuteStartTime],[ExecuteEndTime],[DataStartTime],[DataEndTime],[DataCount],[Status],[IsVerifiedSuccess])
		SELECT [Id],[ProgramId],[BatchName],[ExecuteStartTime],[ExecuteEndTime],[DataStartTime],[DataEndTime],[DataCount],[Status],[IsVerifiedSuccess]
		FROM [dbo].[BatchLog]
		WHERE [ExecuteStartTime] < @ArchiveDate

		DELETE FROM [dbo].[BatchLog]
		WHERE [ExecuteStartTime] < @ArchiveDate
	END TRY
	BEGIN CATCH
		SELECT @ErrorMessage = ERROR_MESSAGE()
		SELECT @ErrorLine = ERROR_LINE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
END
