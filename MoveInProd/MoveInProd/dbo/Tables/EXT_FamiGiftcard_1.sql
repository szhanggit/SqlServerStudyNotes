CREATE TABLE [dbo].[EXT_FamiGiftcard] (
    [Id]             BIGINT       NOT NULL,
    [Barcode1]       VARCHAR (50) NOT NULL,
    [Barcode2]       VARCHAR (50) NOT NULL,
    [TrustStartDate] DATETIME     NULL,
    [TrustEndDate]   DATETIME     NULL,
    CONSTRAINT [PK_EXT_FamiGiftcard_Id] PRIMARY KEY CLUSTERED ([Id] ASC)
);

