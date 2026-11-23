
CREATE PROCEDURE [dbo].[spAddAppLog]
    @Application NVARCHAR(50) ,
    @LoggedOn DATETIME ,
    @ThreadId INT ,
    @Level VARCHAR(50) ,
    @MachineName NVARCHAR(250) = NULL ,
    @Logger NVARCHAR(250) = NULL ,
    @Message NVARCHAR(MAX) = NULL ,
    @Keyword1 NVARCHAR(250) = NULL ,
    @Keyword2 NVARCHAR(250) = NULL ,
    @Keyword3 NVARCHAR(250) = NULL ,
    @KeywordMapping NVARCHAR(250) = NULL ,
    @ActionCategory NVARCHAR(250) = NULL ,
    @ActionType NVARCHAR(250) = NULL ,
    @Operator NVARCHAR(250) = NULL
AS
    BEGIN

        SET NOCOUNT ON;

        INSERT  INTO dbo.AppLog
                ( Application ,
                  LoggedOn ,
                  ThreadId ,
                  Level ,
                  MachineName ,
                  Logger ,
                  Message ,
                  Keyword1 ,
                  Keyword2 ,
                  Keyword3 ,
                  KeywordMapping ,
                  ActionCategory ,
                  ActionType ,
                  Operator
                )
        VALUES  ( @Application ,
                  @LoggedOn ,
                  @ThreadId ,
                  @Level ,
                  @MachineName ,
                  @Logger ,
                  @Message ,
                  @Keyword1 ,
                  @Keyword2 ,
                  @Keyword3 ,
                  @KeywordMapping ,
                  @ActionCategory ,
                  @ActionType ,
                  @Operator
                )

    END
