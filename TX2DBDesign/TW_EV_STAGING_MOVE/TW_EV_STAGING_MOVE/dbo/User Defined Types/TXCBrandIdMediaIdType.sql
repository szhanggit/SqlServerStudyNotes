CREATE TYPE [dbo].[TXCBrandIdMediaIdType] AS TABLE (
    [TXCBrandId] INT NOT NULL,
    [TXCMediaId] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([TXCBrandId] ASC, [TXCMediaId] ASC));

