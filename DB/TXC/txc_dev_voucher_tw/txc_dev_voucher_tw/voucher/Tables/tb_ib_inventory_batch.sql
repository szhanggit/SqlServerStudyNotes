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
    [created_on]                 DATETIME       NOT NULL,
    [is_default]                 BIT            NOT NULL,
    [file_processor_batch_no]    BIGINT         NULL,
    [created_by]                 VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_inventory_batch_sku] FOREIGN KEY ([sku_id]) REFERENCES [voucher].[tb_is_inventory_sku] ([sku_id])
);


GO
CREATE NONCLUSTERED INDEX [IX_inventory_batch_sku_id]
    ON [voucher].[tb_ib_inventory_batch]([sku_id] ASC);

