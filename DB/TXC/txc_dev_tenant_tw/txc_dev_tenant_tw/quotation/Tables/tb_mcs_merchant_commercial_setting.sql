CREATE TABLE [quotation].[tb_mcs_merchant_commercial_setting] (
    [id]                  INT           IDENTITY (1, 1) NOT NULL,
    [merchant_id]         INT           NOT NULL,
    [product_version_id]  INT           NOT NULL,
    [product_id]          INT           NOT NULL,
    [valid_from]          DATETIME      NOT NULL,
    [valid_to]            DATETIME      NOT NULL,
    [is_use_default_cost] BIT           NOT NULL,
    [created_by]          NVARCHAR (50) NOT NULL,
    [created_on]          DATETIME      NOT NULL,
    CONSTRAINT [PK_tb_mcs_merchant_commercial_setting] PRIMARY KEY CLUSTERED ([id] ASC)
);

