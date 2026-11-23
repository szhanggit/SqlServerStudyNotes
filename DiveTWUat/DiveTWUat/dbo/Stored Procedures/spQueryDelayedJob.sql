
CREATE PROCEDURE [dbo].[spQueryDelayedJob]
    @ExecutingTime DATETIME ,
    @ServerCode VARCHAR(50)
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;


        DECLARE @Updated TABLE
            (
              Id BIGINT ,
              ProgramCode VARCHAR(20) ,
              VendorCode VARCHAR(50) ,
              ProductCode NVARCHAR(50) ,
              RequestId VARCHAR(50) ,
              TypeName VARCHAR(200) ,
              OperationCode VARCHAR(50) ,
              JsonArguments NVARCHAR(MAX)
            );

        WITH    DelayedJobCTE
                  AS ( SELECT TOP 100
                                *
                       FROM     DelayedJob WITH ( UPDLOCK, ROWLOCK, READPAST )
                       WHERE    ISNULL(ExecutingStatus, 0) IN ( 0, 2 )
                       ORDER BY Id
                     )
            UPDATE  DelayedJobCTE
            SET     ExecutingStatus = 1 ,
                    ExecutingTime = @ExecutingTime ,
                    ServerCode = @ServerCode
            OUTPUT  Inserted.Id ,
                    Inserted.ProgramCode ,
                    Inserted.VendorCode ,
                    Inserted.ProductCode ,
                    Inserted.RequestId ,
                    Inserted.TypeName ,
                    Inserted.OperationCode ,
                    Inserted.JsonArguments
                    INTO @Updated

        SELECT  *
        FROM    @Updated

    END

