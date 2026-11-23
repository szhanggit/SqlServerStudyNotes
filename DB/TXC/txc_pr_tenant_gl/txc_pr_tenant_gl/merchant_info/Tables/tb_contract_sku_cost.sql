CREATE TABLE [merchant_info].[tb_contract_sku_cost] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [contract_id]      INT             NOT NULL,
    [sku_id]           INT             NOT NULL,
    [cost_without_tax] DECIMAL (18, 4) NOT NULL,
    [valid_start_date] DATETIME        NOT NULL,
    [valid_end_date]   DATETIME        NOT NULL,
    [status_id]        INT             NOT NULL,
    [created_by]       NVARCHAR (50)   NOT NULL,
    [created_datetime] DATETIME        NOT NULL,
    [updated_by]       NVARCHAR (50)   NULL,
    [updated_datetime] DATETIME        NULL,
    [timestamp]        ROWVERSION      NOT NULL,
    [cost_with_tax]    DECIMAL (18, 4) CONSTRAINT [default_contract_sku_cost_with_tax] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tb_contract_sku_cost] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_contract_sku_cost_contract_id] FOREIGN KEY ([contract_id]) REFERENCES [merchant_info].[tb_contract] ([id]),
    CONSTRAINT [FK_contract_sku_cost_sku_id] FOREIGN KEY ([sku_id]) REFERENCES [merchant_info].[tb_contract_sku] ([id]),
    CONSTRAINT [FK_contract_sku_cost_status] FOREIGN KEY ([status_id]) REFERENCES [merchant_info].[tb_sku_status] ([id])
);

