CREATE TABLE [dbo].[TXCProductExternalPropertySync] (
    [RunId]                        VARCHAR (50)   NOT NULL,
    [TXCProductExternalPropertyId] INT            NULL,
    [PropertyName]                 NVARCHAR (100) NULL,
    [PropertyValue]                NVARCHAR (500) NULL,
    [Description]                  NVARCHAR (500) NULL
);


GO
CREATE CLUSTERED INDEX [IX_TXCProductExternalPropertySync]
    ON [dbo].[TXCProductExternalPropertySync]([RunId] ASC, [TXCProductExternalPropertyId] ASC) WITH (FILLFACTOR = 90);

