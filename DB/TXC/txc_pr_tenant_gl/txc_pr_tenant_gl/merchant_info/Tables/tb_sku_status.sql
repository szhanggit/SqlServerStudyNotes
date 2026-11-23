CREATE TABLE [merchant_info].[tb_sku_status] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [value]     NVARCHAR (128) NOT NULL,
    [timestamp] ROWVERSION     NOT NULL,
    CONSTRAINT [pk_tb_sku_status] PRIMARY KEY CLUSTERED ([id] ASC)
);

