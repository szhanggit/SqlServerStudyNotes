CREATE TABLE [dbo].[Batch] (
    [Id]        BIGINT   IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Year]      SMALLINT NOT NULL,
    [Month]     TINYINT  NOT NULL,
    [Day]       TINYINT  NOT NULL,
    [StartTime] DATETIME NOT NULL,
    [EndTime]   DATETIME NULL,
    [BatchType] INT      NOT NULL,
    [Status]    TINYINT  NOT NULL,
    CONSTRAINT [PK_Batch] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = '1--Success
   0--Running
   -1--Fail', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Batch', @level2type = N'COLUMN', @level2name = N'Status';

