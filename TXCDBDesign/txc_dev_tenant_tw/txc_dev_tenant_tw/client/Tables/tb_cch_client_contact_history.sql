CREATE TABLE [client].[tb_cch_client_contact_history] (
    [client_contact_history_id] INT            IDENTITY (1, 1) NOT NULL,
    [client_contact_id]         INT            NOT NULL,
    [client_id]                 INT            NOT NULL,
    [position]                  NVARCHAR (100) NULL,
    [name]                      NVARCHAR (30)  NULL,
    [email]                     NVARCHAR (255) NULL,
    [mobile_no]                 NVARCHAR (50)  NULL,
    [is_active]                 BIT            NOT NULL,
    [timestamp]                 ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_cch_client_contact_history] PRIMARY KEY CLUSTERED ([client_contact_history_id] ASC)
);

