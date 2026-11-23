CREATE TABLE [dbo].[EXT_SG_SerialNumber_Buffer] (
    [VoucherNumber]      VARCHAR (50) NOT NULL,
    [ProgramId]          INT          NOT NULL,
    [VerificationNumber] VARCHAR (50) NULL,
    [SessionId]          VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [index_SessionId]
    ON [dbo].[EXT_SG_SerialNumber_Buffer]([SessionId] ASC);

