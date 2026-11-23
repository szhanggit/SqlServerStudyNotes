CREATE TABLE [dbo].[CSSReceiverOperation] (
    [BeneficiaryInfoId] BIGINT         NOT NULL,
    [VoucherNumber]     VARCHAR (50)   NULL,
    [ActionType]        INT            NOT NULL,
    [ActionResult]      INT            NOT NULL,
    [Operator]          NVARCHAR (50)  NOT NULL,
    [ActionTime]        DATETIME       NOT NULL,
    [Memo]              NVARCHAR (500) NULL
);


GO
CREATE NONCLUSTERED INDEX [idx_CSSReceiverOperation_BeneficiaryInfoId]
    ON [dbo].[CSSReceiverOperation]([BeneficiaryInfoId] ASC);

