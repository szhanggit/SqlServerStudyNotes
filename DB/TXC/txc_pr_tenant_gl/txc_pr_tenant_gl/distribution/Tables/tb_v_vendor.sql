CREATE TABLE [distribution].[tb_v_vendor] (
    [id]                       INT            IDENTITY (1, 1) NOT NULL,
    [name]                     NVARCHAR (100) NOT NULL,
    [is_default]               BIT            CONSTRAINT [DF_distribution.tb_v_vendor_is_default] DEFAULT ((0)) NOT NULL,
    [message_type_id]          SMALLINT       NOT NULL,
    [api_call_settings]        NVARCHAR (MAX) NOT NULL,
    [delivery_status_timezone] VARCHAR (50)   NOT NULL,
    [vendor_code]              VARCHAR (20)   NOT NULL,
    [status_tracking_delay]    INT            NOT NULL,
    [has_bulk_send_api]        BIT            CONSTRAINT [DF_distribution.tb_v_vendor_has_bulk_send_api] DEFAULT ((0)) NOT NULL,
    [has_bulk_status_api]      BIT            CONSTRAINT [DF_distribution.tb_v_vendor_has_bulk_status_api] DEFAULT ((0)) NOT NULL,
    [is_active]                BIT            CONSTRAINT [DF_distribution.tb_v_vendor_is_active] DEFAULT ((1)) NOT NULL,
    [created_on]               DATETIME       NOT NULL,
    [updated_on]               DATETIME       NULL,
    [comment]                  NCHAR (1000)   NULL,
    [provider_code]            NVARCHAR (16)  DEFAULT (substring(CONVERT([nvarchar](36),newid()),(1),(5))) NOT NULL,
    CONSTRAINT [PK_distribution.tb_v_vendor] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UQ_VENDOR_PROVIDERCODE] UNIQUE NONCLUSTERED ([provider_code] ASC)
);

