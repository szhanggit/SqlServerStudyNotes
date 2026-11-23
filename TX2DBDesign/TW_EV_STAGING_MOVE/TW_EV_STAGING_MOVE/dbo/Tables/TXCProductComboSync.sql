CREATE TABLE [dbo].[TXCProductComboSync] (
    [RunId]                    VARCHAR (50)   NOT NULL,
    [TXCProductId]             INT            NOT NULL,
    [TXCChildProductId]        NVARCHAR (100) NOT NULL,
    [TXCChildProductVersionId] INT            NOT NULL,
    [TXCSequence]              INT            NULL,
    [TXCStatus]                BIT            NOT NULL,
    [TX2ProductId]             INT            NULL,
    [TX2ChildProductId]        INT            NULL,
    [TX2ChildProductVersionId] INT            NULL,
    [TX2ProductComboId]        INT            NULL,
    [TX2ProductComboSetId]     INT            NULL
);

