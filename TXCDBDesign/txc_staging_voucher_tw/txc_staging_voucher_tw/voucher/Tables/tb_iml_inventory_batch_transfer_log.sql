CREATE TABLE [voucher].[tb_iml_inventory_batch_transfer_log] (
    [id]                  INT          IDENTITY (1, 1) NOT NULL,
    [from_batch_id]       INT          NOT NULL,
    [to_batch_id]         INT          NOT NULL,
    [transfered_quantity] INT          NOT NULL,
    [created_on]          DATETIME     NOT NULL,
    [created_by]          VARCHAR (50) NOT NULL,
    [row_version]         ROWVERSION   NOT NULL,
    CONSTRAINT [PK_inventory_movement_log_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_inventory_movement_log_from_sku] FOREIGN KEY ([from_batch_id]) REFERENCES [voucher].[tb_ib_inventory_batch] ([id]),
    CONSTRAINT [FK_inventory_movement_log_to_sku] FOREIGN KEY ([to_batch_id]) REFERENCES [voucher].[tb_ib_inventory_batch] ([id])
);

