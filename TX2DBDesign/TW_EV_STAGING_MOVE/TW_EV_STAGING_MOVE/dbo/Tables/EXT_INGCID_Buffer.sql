CREATE TABLE [dbo].[EXT_INGCID_Buffer] (
    [VoucherNumber] VARCHAR (50) NOT NULL,
    [ProgramId]     INT          NOT NULL,
    [GCID]          VARCHAR (50) NOT NULL,
    [SessionId]     VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [index_SessionId]
    ON [dbo].[EXT_INGCID_Buffer]([SessionId] ASC);

