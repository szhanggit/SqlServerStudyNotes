CREATE TABLE [credit].[tb_cqfa_client_quotation_financial_account] (
    [id]                  INT             IDENTITY (1, 1) NOT NULL,
    [client_id]           INT             NOT NULL,
    [quotation_id]        INT             NOT NULL,
    [account_name]        NVARCHAR (100)  NOT NULL,
    [status]              BIT             NOT NULL,
    [currency]            VARCHAR (5)     NOT NULL,
    [balance]             DECIMAL (18, 2) NOT NULL,
    [wallet_id]           NVARCHAR (255)  NOT NULL,
    [client_ext_ref]      NVARCHAR (255)  NULL,
    [client_ext_ref_type] INT             NULL,
    CONSTRAINT [PK_tb_cqfa_client_quotation_financial_account_id] PRIMARY KEY CLUSTERED ([id] ASC)
);

