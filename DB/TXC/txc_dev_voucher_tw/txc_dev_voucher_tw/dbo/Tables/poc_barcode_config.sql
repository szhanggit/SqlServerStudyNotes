CREATE TABLE [dbo].[poc_barcode_config] (
    [voucher_generator_id] INT            NOT NULL,
    [barcode_config]       NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_barcode_configs] PRIMARY KEY CLUSTERED ([voucher_generator_id] ASC)
);

