CREATE TABLE [merchant_info].[tb_contract_cost_rounding_places] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [value]     NVARCHAR (128) NOT NULL,
    [timestamp] ROWVERSION     NOT NULL,
    CONSTRAINT [pk_tb_contract_cost_rounding_places] PRIMARY KEY CLUSTERED ([id] ASC)
);

