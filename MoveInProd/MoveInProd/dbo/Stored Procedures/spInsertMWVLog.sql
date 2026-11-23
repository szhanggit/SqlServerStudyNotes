
CREATE PROCEDURE spInsertMWVLog
    @VoucherId BIGINT
AS
    BEGIN

        SET NOCOUNT ON;

		INSERT INTO [dbo].[MWVLog]
           ([VoucherId]
           ,[CreatedOn])
		VALUES
           (@VoucherId
           ,GETDATE())         
	
    END;
