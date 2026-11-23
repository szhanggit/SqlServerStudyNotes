
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spUpdateAccountBatchActivateInfo]
	@Id BIGINT,
	@Status INT,
	@IsSuccess BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @IsSuccess = 0
    
	BEGIN TRY
		
		UPDATE AccountBatchActivateInfo
		SET [Status] = @Status
		WHERE Id = @Id

		SET @IsSuccess = 1

	END TRY
	BEGIN CATCH
		set @IsSuccess = 0
	END CATCH;
END
