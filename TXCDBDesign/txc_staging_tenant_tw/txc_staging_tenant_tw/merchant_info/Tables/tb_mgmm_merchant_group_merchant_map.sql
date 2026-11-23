CREATE TABLE [merchant_info].[tb_mgmm_merchant_group_merchant_map] (
    [merchant_group_merchant_map_id] INT IDENTITY (1, 1) NOT NULL,
    [merchant_group_id]              INT NOT NULL,
    [merchant_id]                    INT NOT NULL,
    [status]                         BIT NOT NULL,
    CONSTRAINT [PK_tb_mgmp_merchant_group_merchant_map] PRIMARY KEY CLUSTERED ([merchant_group_merchant_map_id] ASC),
    CONSTRAINT [FK_tb_tb_mgmm_merchant_group_merchant_map_tb_m_merchant] FOREIGN KEY ([merchant_id]) REFERENCES [merchant_info].[tb_m_merchant] ([id]),
    CONSTRAINT [FK_tb_tb_mgmm_merchant_group_merchant_map_tb_mg_merchant_group] FOREIGN KEY ([merchant_group_id]) REFERENCES [merchant_info].[tb_mg_merchant_group] ([merchant_group_id]),
    CONSTRAINT [FK_tb_tb_mgmp_merchant_group_merchant_map_tb_m_merchant] FOREIGN KEY ([merchant_id]) REFERENCES [merchant_info].[tb_m_merchant] ([id]),
    CONSTRAINT [FK_tb_tb_mgmp_merchant_group_merchant_map_tb_mg_merchant_group] FOREIGN KEY ([merchant_group_id]) REFERENCES [merchant_info].[tb_mg_merchant_group] ([merchant_group_id])
);

