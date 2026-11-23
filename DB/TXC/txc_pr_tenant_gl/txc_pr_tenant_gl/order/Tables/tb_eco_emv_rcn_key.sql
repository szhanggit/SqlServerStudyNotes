CREATE TABLE [order].[tb_eco_emv_rcn_key] (
    [id]  BIGINT         IDENTITY (1, 1) NOT NULL,
    [rcn] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tb_eco_emv_rcn_key] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_order_tb_eco_emv_rcn_key]
    ON [order].[tb_eco_emv_rcn_key]([rcn] ASC);

