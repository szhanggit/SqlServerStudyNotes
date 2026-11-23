CREATE TABLE [dbo].[AcceptanceLoopMerchantBuffer] (
    [AcceptanceLoopUpdateId] VARCHAR (50) NOT NULL,
    [ProgramIdentityCode]    VARCHAR (20) NOT NULL,
    [ProductExternalId]      INT          NOT NULL,
    [MerchantExternalId]     INT          NOT NULL,
    [CreatedOn]              DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_AcceptanceLoopMerchantBuffer]
    ON [dbo].[AcceptanceLoopMerchantBuffer]([AcceptanceLoopUpdateId] ASC);

