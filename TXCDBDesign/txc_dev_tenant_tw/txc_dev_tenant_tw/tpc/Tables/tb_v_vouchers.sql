CREATE TABLE [tpc].[tb_v_vouchers] (
    [id]             INT             IDENTITY (1, 1) NOT NULL,
    [order_id]       INT             NOT NULL,
    [voucher_number] VARCHAR (50)    NULL,
    [expiry_date]    DATETIME        NULL,
    [amount]         NUMERIC (20, 6) NULL,
    [currency_code]  VARCHAR (50)    NULL,
    [password]       VARCHAR (255)   NULL,
    [misc1]          VARCHAR (255)   NULL,
    [misc2]          VARCHAR (255)   NULL,
    [misc3]          VARCHAR (255)   NULL,
    [status]         TINYINT         DEFAULT ((1)) NOT NULL,
    [created_on]     DATETIME        DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tb_v_vouchers] PRIMARY KEY CLUSTERED ([id] ASC)
);

