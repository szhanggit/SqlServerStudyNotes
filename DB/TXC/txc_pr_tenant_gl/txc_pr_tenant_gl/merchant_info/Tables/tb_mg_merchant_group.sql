CREATE TABLE [merchant_info].[tb_mg_merchant_group] (
    [merchant_group_id] INT        IDENTITY (1, 1) NOT NULL,
    [merchant_id]       INT        NOT NULL,
    [created_on]        DATETIME   DEFAULT (getdate()) NOT NULL,
    [timestamp]         ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_mg_merchant_group] PRIMARY KEY CLUSTERED ([merchant_group_id] ASC),
    CONSTRAINT [FK_tb_mg_merchant_group_tb_m_merchant] FOREIGN KEY ([merchant_id]) REFERENCES [merchant_info].[tb_m_merchant] ([id])
);

