
CREATE PROCEDURE [dbo].[spUpdateSendinBlueDLRInfo]
@UpdatedTable SendinBlueDLRInfoType READONLY,
@IsSuccess bit output
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRANSACTION;
		
		UPDATE ncd SET ncd.AnalyzedTime = UT.AnalyzedTime , ncd.[Status] = UT.[Status] from dbo.SendinBlueDLR ncd with(NOLOCK) INNER JOIN @UpdatedTable UT ON ncd.Id = UT.Id;

		set @IsSuccess = 1;
	    COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		select ERROR_MESSAGE() as Message;
		set @IsSuccess = 0
		ROLLBACK TRANSACTION;
	END CATCH;		

END;
