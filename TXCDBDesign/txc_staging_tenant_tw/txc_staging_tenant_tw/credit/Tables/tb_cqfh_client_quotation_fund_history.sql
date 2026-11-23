CREATE TABLE [credit].[tb_cqfh_client_quotation_fund_history] (
    [id]                                    INT             IDENTITY (1, 1) NOT NULL,
    [client_quotation_financial_account_id] INT             NOT NULL,
    [fund_type]                             TINYINT         NOT NULL,
    [order_reference_id]                    INT             NULL,
    [amount]                                DECIMAL (18, 2) NOT NULL,
    [reference_number]                      NVARCHAR (255)  NOT NULL,
    [transaction_date_time]                 DATETIME        NOT NULL,
    [wallet_balance_after]                  DECIMAL (18, 2) NOT NULL,
    [credit_limit_balance_after]            DECIMAL (18, 2) NOT NULL,
    CONSTRAINT [PK_tb_cqfh_client_quotation_fund_history] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_cqfh_client_quotation_fund_history_tb_cqfa_client_quotation_financial_account] FOREIGN KEY ([client_quotation_financial_account_id]) REFERENCES [credit].[tb_cqfa_client_quotation_financial_account] ([id])
);

