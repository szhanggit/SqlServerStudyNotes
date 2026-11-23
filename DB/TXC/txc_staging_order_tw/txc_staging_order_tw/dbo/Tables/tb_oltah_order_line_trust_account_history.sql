CREATE TABLE [dbo].[tb_oltah_order_line_trust_account_history] (
    [id]                          INT             IDENTITY (1, 1) NOT NULL,
    [order_line_id]               INT             NOT NULL,
    [need_trust_account]          BIT             NOT NULL,
    [order_line_trust_account_id] INT             NULL,
    [trust_account_id]            INT             NULL,
    [trust_account_option]        INT             NULL,
    [trust_account_batch_no]      NVARCHAR (200)  NULL,
    [amount]                      NUMERIC (20, 6) NULL,
    [expiry_policy_id]            INT             NULL,
    [expiry_date]                 DATETIME        NULL,
    [valid_from]                  DATETIME        NULL,
    [valid_to]                    DATETIME        NULL,
    [created_datetime]            DATETIME        NOT NULL,
    [created_by]                  NVARCHAR (50)   NOT NULL,
    [timestamp]                   ROWVERSION      NOT NULL,
    CONSTRAINT [PK_tb_oltah_order_line_trust_account_history] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_oltah_order_line_trust_account_history_tb_ol_order_line] FOREIGN KEY ([order_line_id]) REFERENCES [dbo].[tb_ol_order_line] ([id])
);

