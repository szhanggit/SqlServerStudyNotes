CREATE TABLE [dbo].[tb_oei_order_extend_info] (
    [id]                           INT            NOT NULL,
    [cp_client_code]               NVARCHAR (100) NOT NULL,
    [cp_client_name]               NVARCHAR (255) NOT NULL,
    [voucher_file_name]            NVARCHAR (500) NULL,
    [voucher_file_password]        NVARCHAR (50)  NULL,
    [voucher_file_checksum]        NVARCHAR (128) NULL,
    [voucher_file_generation_time] DATETIME       NULL,
    [created_on]                   DATETIME       NOT NULL,
    [need_send_when_publish]       BIT            NULL,
    [create_order_request_id]      NVARCHAR (50)  NULL,
    [last_updated_on]              DATETIME       NULL,
    [need_regenerate_file]         BIT            NULL,
    [detail_file_name]             NVARCHAR (500) NULL,
    [detail_file_password]         NVARCHAR (50)  NULL,
    [detail_file_checksum]         NVARCHAR (128) NULL,
    [cp_client_id]                 INT            NULL,
    [channel]                      NVARCHAR (15)  NULL,
    [timestamp]                    ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_oei_order_extend_info] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tb_om_order_master] FOREIGN KEY ([id]) REFERENCES [dbo].[tb_om_order_master] ([id])
);

