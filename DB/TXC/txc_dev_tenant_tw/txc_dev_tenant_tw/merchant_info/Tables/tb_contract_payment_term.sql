CREATE TABLE [merchant_info].[tb_contract_payment_term] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [value]     NVARCHAR (128) NOT NULL,
    [timestamp] ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_contract_payment_term] PRIMARY KEY CLUSTERED ([id] ASC)
);

