CREATE TABLE [dbo].[EXT_TW_SoftWorld] (
    [Id]             BIGINT       NOT NULL,
    [Barcode1]       VARCHAR (50) NOT NULL,
    [Barcode2]       VARCHAR (50) NOT NULL,
    [CreatedOn]      DATETIME     NOT NULL,
    [TrustStartDate] DATETIME     NULL,
    [TrustEndDate]   DATETIME     NULL,
    CONSTRAINT [PK_EXT_TW_SoftWorld_VoucherId] PRIMARY KEY CLUSTERED ([Id] ASC)
);

