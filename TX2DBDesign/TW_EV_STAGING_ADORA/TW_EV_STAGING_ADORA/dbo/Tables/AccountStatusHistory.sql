CREATE TABLE [dbo].[AccountStatusHistory] (
    [AccountNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [Status]        INT          NOT NULL,
    [StartTime]     DATETIME     NOT NULL,
    CONSTRAINT [FK_AccountStatusHistory_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([Id])
);

