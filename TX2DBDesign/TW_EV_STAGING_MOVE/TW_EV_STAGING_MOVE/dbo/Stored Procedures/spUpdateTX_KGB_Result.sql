
CREATE PROCEDURE [dbo].[spUpdateTX_KGB_Result]
	@Name NVARCHAR(200) NULL,
	@Result BIGINT NULL,
	@Message VARCHAR(500) NULL = NULL
AS
BEGIN
    IF EXISTS(Select 1 From TX_KGB_Result WHERE [Name] = @Name)
    BEGIN
        UPDATE TX_KGB_Result Set Result = @Result, LastUpdateTime = GETDATE(), [Message] = @Message WHERE [Name] = @Name
    END
END
