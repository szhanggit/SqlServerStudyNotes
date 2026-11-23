CREATE TYPE [merchant_info].[sourceMerchantAddressParameter] AS TABLE (
    [id]                  INT            NULL,
    [detail_address_line] NVARCHAR (500) NULL,
    [district]            NVARCHAR (100) NULL,
    [city_id]             INT            NULL,
    [state_province_id]   INT            NULL,
    [country_id]          INT            NULL,
    [postcode]            NVARCHAR (20)  NULL,
    [longitude]           FLOAT (53)     NULL,
    [latitude]            FLOAT (53)     NULL,
    [status]              TINYINT        NULL);

