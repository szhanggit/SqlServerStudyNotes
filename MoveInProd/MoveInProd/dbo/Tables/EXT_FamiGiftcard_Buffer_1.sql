CREATE TABLE [dbo].[EXT_FamiGiftcard_Buffer] (
    [VoucherNumber]  VARCHAR (50) NOT NULL,
    [ProgramId]      INT          NOT NULL,
    [Barcode1]       VARCHAR (50) NOT NULL,
    [Barcode2]       VARCHAR (50) NOT NULL,
    [TrustStartDate] DATETIME     NULL,
    [TrustEndDate]   DATETIME     NULL,
    [SessionId]      VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EXT_FamiGiftcard_Buffer_SessionId]
    ON [dbo].[EXT_FamiGiftcard_Buffer]([SessionId] ASC);

