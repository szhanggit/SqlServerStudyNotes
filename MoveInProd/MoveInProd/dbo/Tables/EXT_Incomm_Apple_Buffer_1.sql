CREATE TABLE [dbo].[EXT_Incomm_Apple_Buffer] (
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [Barcode1]      VARCHAR (50) NOT NULL,
    [Barcode2]      VARCHAR (50) NOT NULL,
    [SessionId]     VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EXT_Incomm_Apple_Buffer_SessionId]
    ON [dbo].[EXT_Incomm_Apple_Buffer]([SessionId] ASC);

