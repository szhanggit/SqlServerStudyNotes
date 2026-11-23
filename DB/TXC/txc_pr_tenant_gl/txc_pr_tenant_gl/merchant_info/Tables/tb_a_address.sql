CREATE TABLE [merchant_info].[tb_a_address] (
    [id]                   INT            IDENTITY (1, 1) NOT NULL,
    [detail_address_line]  NVARCHAR (500) NULL,
    [district]             NVARCHAR (100) NULL,
    [city_id]              INT            NULL,
    [state_or_province_id] INT            NULL,
    [country_id]           INT            NULL,
    [postcode]             NVARCHAR (20)  NULL,
    [longitude]            FLOAT (53)     NULL,
    [latitude]             FLOAT (53)     NULL,
    [status]               TINYINT        NULL,
    CONSTRAINT [PK_tb_a_address] PRIMARY KEY CLUSTERED ([id] ASC)
);

