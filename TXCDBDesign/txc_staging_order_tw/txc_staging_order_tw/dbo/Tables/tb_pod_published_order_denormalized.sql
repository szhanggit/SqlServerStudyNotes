CREATE TABLE [dbo].[tb_pod_published_order_denormalized] (
    [id]                       BIGINT         IDENTITY (1, 1) NOT NULL,
    [order_id]                 INT            NOT NULL,
    [order_line_id]            INT            NOT NULL,
    [order_line_detail_id]     BIGINT         NOT NULL,
    [voucher_id]               BIGINT         NOT NULL,
    [client_order_number]      NVARCHAR (50)  NULL,
    [unique_external_order_id] NVARCHAR (50)  NULL,
    [quotation_id]             INT            NOT NULL,
    [quotation_number]         NVARCHAR (50)  NOT NULL,
    [client_id]                INT            NOT NULL,
    [client_name]              NVARCHAR (100) NOT NULL,
    [identity_code]            NVARCHAR (50)  NOT NULL,
    [order_number]             NVARCHAR (50)  NOT NULL,
    [mode]                     INT            NOT NULL,
    [publish_datetime]         DATETIME       NOT NULL,
    [package_receiver]         NVARCHAR (100) NULL,
    [package_password]         NVARCHAR (20)  NULL,
    [order_name]               NVARCHAR (200) NOT NULL,
    [mwv_email_template_id]    INT            NULL,
    [export_barcode_info]      INT            NULL,
    [voucher_supplier_id]      INT            NULL,
    [package_pin_receiver]     NVARCHAR (100) NULL,
    [order_channel_id]         INT            NULL,
    [activate_date]            DATETIME       NOT NULL,
    [published_quantity]       INT            NOT NULL,
    [need_trust_account]       BIT            NOT NULL,
    [product_version_id]       INT            NOT NULL,
    [product_name]             NVARCHAR (200) NOT NULL,
    [product_code]             NVARCHAR (50)  NOT NULL,
    [product_type]             TINYINT        NOT NULL,
    [product_base_type]        TINYINT        NOT NULL,
    [order_line_template_id]   INT            NOT NULL,
    [voucher_reservation_code] NVARCHAR (20)  NULL,
    [mobile]                   NVARCHAR (50)  NULL,
    [email]                    NVARCHAR (100) NULL,
    [expiry_scheme_id]         INT            NOT NULL,
    [expiry_date]              DATETIME       NULL,
    [ed_order_number]          NVARCHAR (50)  NULL,
    [name]                     NVARCHAR (100) NULL,
    [language_id]              INT            NULL,
    [face_value]               INT            NULL,
    [face_value_with_tax]      INT            NULL,
    [sold_price]               DECIMAL (18)   NULL,
    [sold_price_with_tax]      DECIMAL (18)   NULL,
    [is_email_delivered]       BIT            NULL,
    [is_sms_delivered]         BIT            NULL,
    [voucher_number]           NVARCHAR (50)  NOT NULL,
    [created_datetime]         DATETIME       NULL,
    [row_version]              ROWVERSION     NOT NULL,
    CONSTRAINT [PK_tb_pod_published_order_denormalized] PRIMARY KEY CLUSTERED ([order_id] ASC, [order_line_id] ASC, [order_line_detail_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_voucher_id]
    ON [dbo].[tb_pod_published_order_denormalized]([voucher_id] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_unique_external_order_id]
    ON [dbo].[tb_pod_published_order_denormalized]([unique_external_order_id] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_client_order_number]
    ON [dbo].[tb_pod_published_order_denormalized]([client_order_number] ASC);

