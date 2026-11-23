
CREATE PROCEDURE spInsertConcurrencyLog
    @RequestId VARCHAR(50) ,
    @UpdatedTime BIGINT ,
    @ConcurrencyLogId BIGINT OUTPUT
AS
    BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
        SET NOCOUNT ON;

        BEGIN TRY
			INSERT  INTO dbo.ConcurrencyLog( RequestId ,UpdatedTime ) VALUES (@RequestId , @UpdatedTime);
			SELECT  @ConcurrencyLogId = SCOPE_IDENTITY();
		END TRY
		BEGIN CATCH
			SELECT  @ConcurrencyLogId = 0;
		END CATCH
    END;
