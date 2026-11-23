CREATE TABLE [dbo].[tb_olta_order_line_trust_account] (
    [id]                     INT             IDENTITY (1, 1) NOT NULL,
    [order_line_id]          INT             NOT NULL,
    [trust_account_id]       INT             NOT NULL,
    [trust_account_option]   INT             NOT NULL,
    [trust_account_batch_no] NVARCHAR (200)  NULL,
    [amount]                 NUMERIC (20, 6) NULL,
    [expiry_policy_id]       INT             NOT NULL,
    [expiry_date]            DATETIME        NULL,
    [valid_from]             DATETIME        NOT NULL,
    [valid_to]               DATETIME        NOT NULL,
    [created_datetime]       DATETIME        NULL,
    [row_version]            ROWVERSION      NOT NULL,
    CONSTRAINT [PK_tb_olta_order_line_trust_account] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_olta_order_line_trust_account_tb_ol_order_line] FOREIGN KEY ([order_line_id]) REFERENCES [dbo].[tb_ol_order_line] ([id])
);

