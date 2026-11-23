CREATE TABLE [backup].[tb_mgmm_merchant_group_merchant_map] (
    [merchant_group_merchant_map_id] INT IDENTITY (1, 1) NOT NULL,
    [merchant_group_id]              INT NOT NULL,
    [merchant_id]                    INT NOT NULL,
    [status]                         BIT NOT NULL
);

