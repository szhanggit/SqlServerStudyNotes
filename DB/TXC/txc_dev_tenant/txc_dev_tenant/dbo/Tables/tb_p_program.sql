CREATE TABLE [dbo].[tb_p_program] (
    [id]                        INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [identity_code]             VARCHAR (20)   NOT NULL,
    [name]                      NVARCHAR (50)  NOT NULL,
    [display_name]              NVARCHAR (200) NULL,
    [timeoffset]                VARCHAR (6)    NOT NULL,
    [merchant_max_fail_number]  INT            NOT NULL,
    [shop_max_fail_number]      INT            NOT NULL,
    [terminal_max_fail_number]  INT            NOT NULL,
    [is_default_program]        BIT            DEFAULT ((0)) NOT NULL,
    [date_format_string]        VARCHAR (25)   NULL,
    [datetime_format_string]    VARCHAR (25)   NULL,
    [is_edenred]                BIT            DEFAULT ((0)) NOT NULL,
    [active_date_format_string] VARCHAR (25)   NULL,
    [tenant_id]                 INT            NOT NULL,
    [updated_on]                DATETIME       NULL,
    CONSTRAINT [PK_program_id] PRIMARY KEY NONCLUSTERED ([id] ASC),
    CONSTRAINT [FK_program_ref_tenant_id] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_tbi_tenant_basic_information] ([tenant_basic_info_id]),
    CONSTRAINT [UK_program_identity_code] UNIQUE CLUSTERED ([identity_code] ASC, [tenant_id] ASC)
);

