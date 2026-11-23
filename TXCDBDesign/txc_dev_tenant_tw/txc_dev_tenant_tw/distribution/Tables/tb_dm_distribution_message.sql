CREATE TABLE [distribution].[tb_dm_distribution_message] (
    [id]                           INT            IDENTITY (1, 1) NOT NULL,
    [message_id]                   NVARCHAR (50)  NOT NULL,
    [tenant_id]                    INT            NOT NULL,
    [distribution_message_type_id] INT            NOT NULL,
    [processing_status_id]         INT            NOT NULL,
    [distribution_message_payload] NVARCHAR (MAX) NOT NULL,
    [message_version]              NVARCHAR (10)  NOT NULL,
    [priority_type]                INT            NULL,
    [created_on]                   DATETIME       NOT NULL,
    [last_updated_on]              DATETIME       NULL,
    CONSTRAINT [PK_tb_dm_distribution_message] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_dm_distribution_message] UNIQUE NONCLUSTERED ([message_id] ASC)
);

