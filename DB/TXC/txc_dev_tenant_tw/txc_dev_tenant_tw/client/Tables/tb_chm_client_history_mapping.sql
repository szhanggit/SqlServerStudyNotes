CREATE TABLE [client].[tb_chm_client_history_mapping] (
    [client_history_mapping_id] INT        IDENTITY (1, 1) NOT NULL,
    [client_history_id]         INT        NOT NULL,
    [client_contact_history_id] INT        NOT NULL,
    [timestamp]                 ROWVERSION NOT NULL,
    CONSTRAINT [PK_tb_chm_client_history_mapping] PRIMARY KEY CLUSTERED ([client_history_mapping_id] ASC)
);

