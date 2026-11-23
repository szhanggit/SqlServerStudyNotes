CREATE TABLE [dbo].[MasterTranInfoStaging] (
    [AccountNumber]    VARCHAR (50) NOT NULL,
    [TranCode]         VARCHAR (50) NOT NULL,
    [ChildProductId]   INT          NOT NULL,
    [TranAmountRemain] INT          NOT NULL,
    [VersionId]        INT          NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_MasterTranInfoStaging]
    ON [dbo].[MasterTranInfoStaging]([AccountNumber] ASC, [TranCode] ASC);

