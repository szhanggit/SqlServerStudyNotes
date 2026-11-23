CREATE TABLE [dbo].[EXT_TW_SEBarcode_Temp] (
    [SessionId]      VARCHAR (50) NOT NULL,
    [ProgramId]      INT          NOT NULL,
    [VoucherNumber]  VARCHAR (30) NOT NULL,
    [Barcode1]       VARCHAR (50) NOT NULL,
    [Barcode2]       VARCHAR (50) NOT NULL,
    [TrustStartDate] DATETIME     NULL,
    [TrustEndDate]   DATETIME     NULL,
    CONSTRAINT [UK_EXT_TW_SEBarcode_Temp_ProgramId_VoucherNumber] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC)
);

