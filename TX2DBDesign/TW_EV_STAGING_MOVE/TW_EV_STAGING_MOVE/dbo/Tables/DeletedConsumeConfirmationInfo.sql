CREATE TABLE [dbo].[DeletedConsumeConfirmationInfo] (
    [Id]                               INT            IDENTITY (1, 1) NOT NULL,
    [DeletedConsumeConfirmationInfoId] BIGINT         NULL,
    [VoucherId]                        BIGINT         NULL,
    [ConfirmationInfo]                 NVARCHAR (200) NULL,
    [LastUpdatedOn]                    DATETIME       NULL,
    [BatchTransactionDetailId]         INT            NOT NULL,
    [SessionId]                        VARCHAR (100)  NULL,
    [BackupOn]                         DATETIME       NULL,
    [Channel]                          VARCHAR (100)  NULL,
    [Comment]                          VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

