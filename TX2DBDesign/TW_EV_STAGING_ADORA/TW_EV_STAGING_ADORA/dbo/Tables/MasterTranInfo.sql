CREATE TABLE [dbo].[MasterTranInfo] (
    [AccountNumber]    VARCHAR (50) NOT NULL,
    [TranCode]         VARCHAR (50) NOT NULL,
    [ChildProductId]   INT          NOT NULL,
    [TranAmountRemain] INT          NOT NULL,
    [VersionId]        INT          NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IDX_MasterTranInfo_AccountNumber]
    ON [dbo].[MasterTranInfo]([AccountNumber] ASC);

