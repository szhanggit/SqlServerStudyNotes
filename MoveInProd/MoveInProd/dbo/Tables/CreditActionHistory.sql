CREATE TABLE [dbo].[CreditActionHistory] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]    INT           NOT NULL,
    [Operater]    NVARCHAR (50) NOT NULL,
    [ActionType]  INT           NOT NULL,
    [Description] VARCHAR (20)  NOT NULL,
    [CreateDate]  DATETIME      NOT NULL,
    CONSTRAINT [PK_CreditActionHistory_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Index_CreditActionHistory_ClientId]
    ON [dbo].[CreditActionHistory]([ClientId] ASC);

