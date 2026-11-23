CREATE TABLE [credit].[tb_cc_client_credit] (
    [id]               INT             IDENTITY (1, 1) NOT NULL,
    [client_id]        INT             NOT NULL,
    [credit_limit]     DECIMAL (18, 2) NOT NULL,
    [available_credit] DECIMAL (18, 2) NOT NULL,
    [client_email]     NVARCHAR (200)  NOT NULL,
    [extend_email]     NVARCHAR (200)  NOT NULL,
    [mail_send_status] INT             NOT NULL,
    [modify_version]   INT             NOT NULL,
    CONSTRAINT [PK_client_credit_id] PRIMARY KEY CLUSTERED ([id] ASC)
);

