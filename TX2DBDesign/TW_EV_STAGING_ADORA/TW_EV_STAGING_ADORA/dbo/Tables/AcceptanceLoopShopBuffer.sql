CREATE TABLE [dbo].[AcceptanceLoopShopBuffer] (
    [AcceptanceLoopUpdateId] VARCHAR (50) NOT NULL,
    [ProgramIdentityCode]    VARCHAR (20) NOT NULL,
    [ProductExternalId]      INT          NOT NULL,
    [ShopExternalId]         INT          NOT NULL,
    [CreatedOn]              DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_AcceptanceLoopShopBuffer]
    ON [dbo].[AcceptanceLoopShopBuffer]([AcceptanceLoopUpdateId] ASC);

