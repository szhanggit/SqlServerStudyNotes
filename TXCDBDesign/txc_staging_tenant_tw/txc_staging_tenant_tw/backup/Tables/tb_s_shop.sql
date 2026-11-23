CREATE TABLE [backup].[tb_s_shop] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [identity_code]    NVARCHAR (50)  NOT NULL,
    [name]             NVARCHAR (100) NOT NULL,
    [merchant_id]      INT            NOT NULL,
    [address_id]       INT            NOT NULL,
    [external_code]    NVARCHAR (50)  NULL,
    [contact_name]     NVARCHAR (50)  NULL,
    [contact_phone]    NVARCHAR (50)  NULL,
    [security_key]     NVARCHAR (48)  NOT NULL,
    [status]           TINYINT        NULL,
    [subsidiary_uen]   NVARCHAR (30)  NULL,
    [subsidiary_name]  NVARCHAR (100) NULL,
    [created_on]       DATETIME       NOT NULL,
    [last_modified_on] DATETIME       NOT NULL,
    [last_modifier]    NVARCHAR (50)  NOT NULL,
    [work_key_id]      INT            NULL,
    [contact_name2]    NVARCHAR (50)  NULL,
    [contact_phone2]   NVARCHAR (50)  NULL,
    [timestamp]        ROWVERSION     NOT NULL
);

