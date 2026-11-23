CREATE TABLE [dbo].[EXT_TW_ProductBarcodeSetting] (
    [Id]                    INT          NOT NULL,
    [BarcodeType]           VARCHAR (20) NOT NULL,
    [IsBarcode1DisplayText] BIT          NULL,
    [IsBarcode2DisplayText] BIT          NULL,
    [IsBarcode3DisplayText] BIT          NULL,
    [IsBarcode4DisplayText] BIT          NULL,
    CONSTRAINT [PK_EXT_TW_ProductBarcodeSetting_ProductId] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

