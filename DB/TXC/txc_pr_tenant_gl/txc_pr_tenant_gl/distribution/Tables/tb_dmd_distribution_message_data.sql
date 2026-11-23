CREATE TABLE [distribution].[tb_dmd_distribution_message_data] (
    [id]                      INT            IDENTITY (1, 1) NOT NULL,
    [distribution_message_id] INT            NOT NULL,
    [distribution_sender_id]  INT            NOT NULL,
    [processing_status_id]    INT            NOT NULL,
    [provider_code]           NVARCHAR (16)  NULL,
    [vendor_transaction_id]   NVARCHAR (255) NULL,
    [vendor_status]           NVARCHAR (255) NULL,
    [vendor_status_datetime]  DATETIME       NULL,
    [sent_datetime]           DATETIME       NULL,
    [status_updated_on]       DATETIME       NULL,
    [created_on]              DATETIME       NOT NULL,
    [consumer_service_ref_id] INT            NULL,
    [template_verson_id]      INT            NULL,
    [template_content_index]  SMALLINT       NULL,
    CONSTRAINT [PK_tb_dmd_distribution_message_data] PRIMARY KEY CLUSTERED ([id] ASC)
);

