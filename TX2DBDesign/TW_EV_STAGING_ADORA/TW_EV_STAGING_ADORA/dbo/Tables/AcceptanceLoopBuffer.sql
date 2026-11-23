CREATE TABLE [dbo].[AcceptanceLoopBuffer] (
    [AcceptanceLoopUpdateId] VARCHAR (50) NOT NULL,
    [ProgramIdentityCode]    VARCHAR (20) NOT NULL,
    [ProductExternalId]      INT          NOT NULL,
    [Status]                 INT          NOT NULL,
    [CreatedOn]              DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_AcceptanceLoopBuffer]
    ON [dbo].[AcceptanceLoopBuffer]([AcceptanceLoopUpdateId] ASC);

