CREATE TABLE [dbo].[AcceptanceLoopCategoryBuffer] (
    [AcceptanceLoopUpdateId]     VARCHAR (50) NOT NULL,
    [ProgramIdentityCode]        VARCHAR (20) NOT NULL,
    [ProductExternalId]          INT          NOT NULL,
    [MerchantCategoryExternalId] INT          NOT NULL,
    [CreatedOn]                  DATETIME     NOT NULL
);


GO
CREATE CLUSTERED INDEX [IX_AcceptanceLoopCategoryBuffer]
    ON [dbo].[AcceptanceLoopCategoryBuffer]([AcceptanceLoopUpdateId] ASC);

