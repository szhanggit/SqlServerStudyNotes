CREATE TABLE [tpc].[tb_vp_vendor_products] (
    [id]                  BIGINT          IDENTITY (1, 1) NOT NULL,
    [program_code]        VARCHAR (20)    NOT NULL,
    [vendor_id]           INT             NOT NULL,
    [product_code]        VARCHAR (50)    NOT NULL,
    [vendor_product_code] VARCHAR (50)    NOT NULL,
    [product_name]        NVARCHAR (250)  NOT NULL,
    [currency_code]       VARCHAR (50)    NULL,
    [amount]              NUMERIC (20, 6) NULL,
    [description]         NVARCHAR (500)  NULL,
    [status]              TINYINT         DEFAULT ((1)) NOT NULL,
    [country_code]        VARCHAR (50)    NULL,
    [rsv1]                VARCHAR (255)   NULL,
    [rsv2]                VARCHAR (255)   NULL,
    [rsv3]                VARCHAR (255)   NULL,
    [valid_days]          INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tb_vp_vendor_products] PRIMARY KEY CLUSTERED ([id] ASC)
);

