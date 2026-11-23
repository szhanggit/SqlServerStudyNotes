CREATE TABLE [merchant_info].[tb_almss_acceptance_loop_merchant_shop_staging] (
    [session_id]                       VARCHAR (50)   NOT NULL,
    [acceptance_loop_merchant_shop_id] INT            NOT NULL,
    [acceptance_loop_merchant_id]      INT            NOT NULL,
    [shop_id]                          INT            NOT NULL,
    [status]                           BIT            NOT NULL,
    [last_updated_by]                  NVARCHAR (250) NULL,
    [last_updated_on]                  DATETIME       NULL,
    CONSTRAINT [PK_tb_almss_acceptance_loop_merchant_shop_staging] PRIMARY KEY CLUSTERED ([session_id] ASC, [acceptance_loop_merchant_shop_id] ASC)
);

