CREATE TABLE [merchant_info].[tb_vg_voucher_generator] (
    [id]          TINYINT        IDENTITY (1, 1) NOT NULL,
    [description] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_vg_voucher_generator] PRIMARY KEY CLUSTERED ([id] ASC)
);

