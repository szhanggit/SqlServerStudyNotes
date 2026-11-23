CREATE TABLE [dbo].[tb_oqsq_order_quotation_served_quantity] (
    [id]                 INT        IDENTITY (1, 1) NOT NULL,
    [quotation_id]       INT        NOT NULL,
    [product_version_id] INT        NOT NULL,
    [served_quantity]    INT        NOT NULL,
    [remaining_quantity] INT        NULL,
    [timestamp]          ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_oqsq_order_quotation_served_quantity] PRIMARY KEY CLUSTERED ([id] ASC)
);

