CREATE TABLE [dbo].[tb_c_countries] (
    [country_id]      INT           IDENTITY (1, 1) NOT NULL,
    [country]         VARCHAR (128) NOT NULL,
    [country_code]    VARCHAR (5)   NOT NULL,
    [currency_symbol] VARCHAR (8)   NULL,
    [is_active]       BIT           NULL,
    PRIMARY KEY CLUSTERED ([country_id] ASC)
);

