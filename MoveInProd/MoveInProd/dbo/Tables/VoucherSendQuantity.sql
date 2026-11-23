CREATE TABLE [dbo].[VoucherSendQuantity] (
    [Id]                  BIGINT NOT NULL,
    [CSEmailSendQuantity] INT    NULL,
    [CSSMSSendQuantity]   INT    NULL,
    CONSTRAINT [PK_VoucherSendQuantity_Id] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

