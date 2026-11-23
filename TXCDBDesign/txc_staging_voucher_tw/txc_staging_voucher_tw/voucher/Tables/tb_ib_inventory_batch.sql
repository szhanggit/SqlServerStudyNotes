CREATE TABLE [voucher].[tb_ib_inventory_batch] (
    [id]                         INT            IDENTITY (1, 1) NOT NULL,
    [sku_id]                     INT            NOT NULL,
    [quantity]                   INT            NOT NULL,
    [remaining_quantity]         INT            NOT NULL,
    [locked_quantity]            INT            NOT NULL,
    [issue_available_start_date] DATETIME       NULL,
    [issue_available_end_date]   DATETIME       NULL,
    [expiry_date]                DATETIME       NULL,
    [trust_account_end_date]     DATETIME       NULL,
    [reservation_code]           NVARCHAR (100) NULL,
    [batch_processor_batch_id]   BIGINT         NULL,
    [is_default]                 BIT            NOT NULL,
    [created_on]                 DATETIME       NOT NULL,
    [created_by]                 VARCHAR (50)   NULL,
    [row_version]                ROWVERSION     NOT NULL,
    CONSTRAINT [PK_inventory_batch_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_inventory_batch_sku] FOREIGN KEY ([sku_id]) REFERENCES [voucher].[tb_is_inventory_sku] ([sku_id])
);


GO
CREATE NONCLUSTERED INDEX [IX_inventory_batch_sku_id]
    ON [voucher].[tb_ib_inventory_batch]([sku_id] ASC);

