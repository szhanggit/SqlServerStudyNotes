CREATE TABLE [dbo].[EXT_BOOKS_Prepaid_Buffer] (
    [VoucherNumber]  VARCHAR (50) NOT NULL,
    [ProgramId]      INT          NOT NULL,
    [TrustStartDate] DATETIME     NOT NULL,
    [TrustEndDate]   DATETIME     NOT NULL,
    [SessionId]      VARCHAR (50) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [Index_EXT_BOOKS_Prepaid_Buffer_SessionId]
    ON [dbo].[EXT_BOOKS_Prepaid_Buffer]([SessionId] ASC);

