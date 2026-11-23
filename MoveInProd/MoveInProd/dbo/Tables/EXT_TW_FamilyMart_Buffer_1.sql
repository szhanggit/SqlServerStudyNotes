CREATE TABLE [dbo].[EXT_TW_FamilyMart_Buffer] (
    [SessionId]       VARCHAR (50) NOT NULL,
    [SubSessionId]    VARCHAR (50) NOT NULL,
    [ProgramId]       INT          NOT NULL,
    [VoucherNumber]   VARCHAR (30) NOT NULL,
    [Barcode1]        VARCHAR (50) NOT NULL,
    [Barcode2]        VARCHAR (50) NOT NULL,
    [Barcode3]        VARCHAR (50) NOT NULL,
    [Barcode4]        VARCHAR (50) NOT NULL,
    [ReservationCode] VARCHAR (20) NULL,
    CONSTRAINT [UK_EXT_TW_FamilyMart_Buffer_ProgramId_VoucherNumber] UNIQUE NONCLUSTERED ([ProgramId] ASC, [VoucherNumber] ASC) WITH (FILLFACTOR = 90)
);

