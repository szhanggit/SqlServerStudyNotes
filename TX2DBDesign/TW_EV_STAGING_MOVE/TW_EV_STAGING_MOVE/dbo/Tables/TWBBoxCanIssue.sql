CREATE TABLE [dbo].[TWBBoxCanIssue] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [ClientName] NVARCHAR (100) NOT NULL,
    [CanIssue]   BIT            NOT NULL,
    [UpdateTime] DATETIME       NOT NULL,
    [Memo]       VARCHAR (100)  NULL,
    CONSTRAINT [PK_TWBBoxCanIssue_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_TWBBoxCanIssue_ClientName]
    ON [dbo].[TWBBoxCanIssue]([ClientName] ASC);

