CREATE TABLE [credit].[tb_cfh_client_fund_history] (
    [id]                          INT             IDENTITY (1, 1) NOT NULL,
    [client_financial_account_id] INT             NOT NULL,
    [fund_type]                   TINYINT         NOT NULL,
    [order_reference_id]          INT             NULL,
    [amount]                      DECIMAL (18, 2) NOT NULL,
    [reference_number]            NVARCHAR (255)  NOT NULL,
    [tranasction_date_time]       DATETIME        NOT NULL,
    [wallet_balance_after]        DECIMAL (18, 2) NOT NULL,
    [credit_limit_balance_after]  DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_tb_cfh_client_fund_history_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_cfh_client_fund_history_tb_cfa_client_financial_account] FOREIGN KEY ([client_financial_account_id]) REFERENCES [credit].[tb_cqfa_client_quotation_financial_account] ([id])
);

