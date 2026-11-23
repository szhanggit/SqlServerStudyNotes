CREATE PROC spCreateAccount
    @SessionId AS VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE  TOP(1500)  dbo.AccountBuffer2
    SET     SessionId = @SessionId ,
            SessionTime = GETUTCDATE()
	OUTPUT Inserted.*;
END