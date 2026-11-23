CREATE TABLE [backup].[tb_a_address] (
    [address_id]          INT            IDENTITY (1, 1) NOT NULL,
    [detail_address_line] NVARCHAR (500) NULL,
    [district]            NVARCHAR (100) NULL,
    [city_id]             INT            NULL,
    [state_province_id]   INT            NULL,
    [postcode]            NVARCHAR (20)  NULL,
    [country_id]          INT            NULL,
    [longitude]           FLOAT (53)     NULL,
    [latitude]            FLOAT (53)     NULL,
    [status]              TINYINT        NOT NULL,
    [tx2id]               INT            NULL,
    [timestamp]           ROWVERSION     NOT NULL
);

