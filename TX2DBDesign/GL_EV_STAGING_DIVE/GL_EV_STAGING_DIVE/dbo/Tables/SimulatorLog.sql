CREATE TABLE [dbo].[SimulatorLog] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Content]    NVARCHAR (MAX) NULL,
    [CreateTime] DATETIME       NOT NULL,
    CONSTRAINT [PK_SimulatorLog_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

