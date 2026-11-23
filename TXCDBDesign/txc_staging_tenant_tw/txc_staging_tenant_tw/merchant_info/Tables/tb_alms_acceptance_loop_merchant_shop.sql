CREATE TABLE [merchant_info].[tb_alms_acceptance_loop_merchant_shop] (
    [acceptance_loop_merchant_shop_id] INT            IDENTITY (1, 1) NOT NULL,
    [acceptance_loop_merchant_id]      INT            NOT NULL,
    [shop_id]                          INT            NOT NULL,
    [status]                           BIT            NOT NULL,
    [created_by]                       NVARCHAR (250) NOT NULL,
    [created_on]                       DATETIME       NOT NULL,
    [last_updated_by]                  NVARCHAR (250) NULL,
    [last_updated_on]                  DATETIME       NULL,
    [timestamp]                        ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_alms_acceptance_loop_merchant_shop] PRIMARY KEY CLUSTERED ([acceptance_loop_merchant_shop_id] ASC),
    CONSTRAINT [FK_tb_alms_acceptance_loop_merchant_shop_tb_alm_acceptance_loop_merchant] FOREIGN KEY ([acceptance_loop_merchant_id]) REFERENCES [merchant_info].[tb_alm_acceptance_loop_merchant] ([acceptance_loop_merchant_id]),
    CONSTRAINT [FK_tb_alms_acceptance_loop_merchant_shop_tb_s_shop] FOREIGN KEY ([shop_id]) REFERENCES [merchant_info].[tb_s_shop] ([id])
);

