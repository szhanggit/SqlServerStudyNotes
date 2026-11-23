CREATE TABLE [tpc].[tb_o_orders] (
    [id]           INT          IDENTITY (1, 1) NOT NULL,
    [program_code] VARCHAR (20) NOT NULL,
    [vendor_code]  VARCHAR (50) NOT NULL,
    [product_code] VARCHAR (50) NOT NULL,
    [request_id]   VARCHAR (50) NOT NULL,
    [status]       TINYINT      DEFAULT ((1)) NOT NULL,
    [created_on]   DATETIME     DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tb_o_orders] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_o_orders_request_id] UNIQUE NONCLUSTERED ([program_code] ASC, [vendor_code] ASC, [product_code] ASC, [request_id] ASC)
);

