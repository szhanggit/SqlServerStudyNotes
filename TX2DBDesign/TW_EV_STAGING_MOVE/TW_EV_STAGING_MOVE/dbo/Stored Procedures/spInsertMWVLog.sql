
CREATE PROCEDURE spInsertMWVLog
    @VoucherId BIGINT
AS
    BEGIN
	 -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

		INSERT INTO [dbo].[MWVLog]
           ([VoucherId]
           ,[CreatedOn])
		VALUES
           (@VoucherId
           ,GETDATE())         
	
    END;
