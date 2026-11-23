CREATE TABLE [dbo].[ArchiveLog] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [MessageType]     INT          NOT NULL,
    [ArchiveDateTime] DATETIME     NOT NULL,
    [CutOffDateTime]  DATETIME     NOT NULL,
    [SessionId]       VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ArchiveLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

