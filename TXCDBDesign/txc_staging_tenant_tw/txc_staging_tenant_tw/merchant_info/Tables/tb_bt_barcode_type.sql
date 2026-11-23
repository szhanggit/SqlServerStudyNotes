CREATE TABLE [merchant_info].[tb_bt_barcode_type] (
    [id]          TINYINT        IDENTITY (1, 1) NOT NULL,
    [description] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_bt_barcode_type] PRIMARY KEY CLUSTERED ([id] ASC)
);

