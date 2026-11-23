CREATE TABLE [dbo].[tb_eqom_emv_quotation_order_map] (
    [id]           BIGINT IDENTITY (1, 1) NOT NULL,
    [quotation_id] INT    NOT NULL,
    [order_id]     INT    NOT NULL,
    CONSTRAINT [PK_tb_eqom_emv_quotation_order_map] PRIMARY KEY CLUSTERED ([id] ASC)
);

