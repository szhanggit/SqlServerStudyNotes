CREATE TABLE [dbo].[ProductBarcodeSetting] (
    [Id]                        INT          NOT NULL,
    [Barcode1Type]              VARCHAR (20) NULL,
    [IsBarcode1DisplayText]     BIT          NULL,
    [IsBarcode1APIEnabled]      BIT          NULL,
    [Barcode2Type]              VARCHAR (20) NULL,
    [IsBarcode2DisplayText]     BIT          NULL,
    [IsBarcode2APIEnabled]      BIT          NULL,
    [Barcode3Type]              VARCHAR (20) NULL,
    [IsBarcode3DisplayText]     BIT          NULL,
    [IsBarcode3APIEnabled]      BIT          NULL,
    [Barcode4Type]              VARCHAR (20) NULL,
    [IsBarcode4DisplayText]     BIT          NULL,
    [IsBarcode4APIEnabled]      BIT          NULL,
    [ShowcodeType]              VARCHAR (20) NULL,
    [IsShowcodeTypeDisplayText] BIT          NULL,
    [IsShowcodeTypeEnabled]     BIT          NULL,
    CONSTRAINT [PK_ProductBarcodeSetting_ProductId] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90)
);

