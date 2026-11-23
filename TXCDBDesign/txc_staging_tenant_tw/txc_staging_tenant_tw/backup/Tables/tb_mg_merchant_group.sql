CREATE TABLE [backup].[tb_mg_merchant_group] (
    [merchant_group_id] INT      IDENTITY (1, 1) NOT NULL,
    [merchant_id]       INT      NOT NULL,
    [created_on]        DATETIME NOT NULL
);

