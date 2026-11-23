CREATE TABLE [dbo].[EMV_ClientOrderTask] (
    [Id]          INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Priority]    INT      NOT NULL,
    [Status]      TINYINT  NOT NULL,
    [CreatedTime] DATETIME NOT NULL,
    [UpdatedTime] DATETIME NOT NULL,
    CONSTRAINT [PK_EMV_ClientOrderTask] PRIMARY KEY CLUSTERED ([Id] ASC)
);

