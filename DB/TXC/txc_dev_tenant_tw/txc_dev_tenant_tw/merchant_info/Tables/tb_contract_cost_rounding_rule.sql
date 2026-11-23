CREATE TABLE [merchant_info].[tb_contract_cost_rounding_rule] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [value]     NVARCHAR (128) NOT NULL,
    [timestamp] ROWVERSION     NOT NULL,
    CONSTRAINT [pk_tb_contract_cost_rounding_rule] PRIMARY KEY CLUSTERED ([id] ASC)
);

